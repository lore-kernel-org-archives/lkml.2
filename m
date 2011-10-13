Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1JMXyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:54:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33830 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JMXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:54:34 -0400
Date: Thu, 13 Oct 2011 16:54:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: andre.goddard@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix strim() semantics for strings that have only blanks
Message-Id: <20111013165431.b84ffab4.akpm@linux-foundation.org>
In-Reply-To: <1318408317.2891.3.camel@br98xy6r>
References: <1318408317.2891.3.camel@br98xy6r>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 10:31:57 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Hello Andre,
> 
> With git commit 84c95c9acf088c99d8793d78036b67faa5d0b851 a patch from
> you went upstream where you wanted to improve the performance of the
> strim() function.
> 
> Unfortunately this changed the semantics of strim() and broke my code. Before
> the patch it was possible to use strim() without using the return value for
> removing trailing spaces from strings that had either only blanks or only
> trailing blanks.
> 
> Now this does not work any longer for strings that *only* have blanks.
> 
> Before patch: "   " -> ""    (empty string)
> After patch:  "   " -> "   " (no change)
> 
> I think we should remove your patch to restore the old behavior.
> 
> >From the description (lib/string.c):
> 
>  * Note that the first trailing whitespace is replaced with a %NUL-terminator
> 
> => The first trailing whitespace of a string that only has whitespace
>    characters is the first whitespace

Yes, that change makes sense.

> Also strim() explicitly does not have "__must_check", in order to use it
> without using the return value.
> 

This observation seems to have nothing to do with the patch?

I think that strim() _should_ have __must_check annotation (which means
that strim() simply disappears, which is good).  It is only safe to
ignore the strim() return value if the caller knows that the string
started with a non-space.  The number of situations where this is
guaranteed are faily small, I suspect.  Whereas the chances of someone
screwing this up are pretty high :(


