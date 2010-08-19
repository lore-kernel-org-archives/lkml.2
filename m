Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0HSPaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:30:35 -0400
Received: from xenotime.net ([72.52.115.56]:34957 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752030Ab0HSPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:30:34 -0400
Date: Thu, 19 Aug 2010 08:30:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel-doc problem
Message-Id: <20100819083028.6509ab3e.rdunlap@xenotime.net>
In-Reply-To: <1282224019.4507.3.camel@jlt3.sipsolutions.net>
References: <1282224019.4507.3.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 15:20:19 +0200 Johannes Berg wrote:

> Randy, all,
> 
> I'm running into a problem where something that I want to be part of a
> description of a struct member or function parameter gets parsed as a
> new section. You can easily see the problem by running below test file
> through kernel-doc, clearly the intent is not to have a new section in
> the middle of function argument descriptions, but I have no idea how I
> could fix this.
> 
> I'd appreciate if you could take a look.
> 
> Thanks,
> Johannes
> 
> --- here's the file ---
> /**
>  * fn - test
>  *
>  * @a: This is just a non-sense and totally useless dummy function
>  *	argument: it has absolutely no effect.
>  */
> void fn(int a)
> {
> }

Colons (':') are bad.  They cause a section instance.
I don't know how to fix it (inside kernel-doc or docproc or xmlto or wherever).
Sometimes I change colon to "--" or "." or something that makes some sense,
but colon is still the better choice if it would work.

The word "example" has a similar problem.  It causes an <informalexample>
markup to begin, but it's not always terminated properly.
See recent commit 3d2be54bab7efd97b642838b9c883869ca5b98be.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
