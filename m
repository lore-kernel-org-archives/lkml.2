Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab0FBEhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:37:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab0FBEg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:36:58 -0400
Date: Tue, 1 Jun 2010 21:32:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006021239.42006.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006012129420.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org> <201006021239.42006.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> > I would like to note that your original "fix things by dropping the lock" 
> > patch that I hated so much had this exact bug too. Making this a good 
> > example of _why_ it's basically always wrong to drop locks in the middle - 
> > even if you claimed you knew and understood the locking.
> 
> And I would like to note that it didn't :)  It grabbed references only on
> completed modules.

Right you are, I misread the patch. You re-did the whole module lookup, 
something that the original code didn't do. And yes, that should be safe.

			Linus
