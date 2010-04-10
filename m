Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0DJQfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:35:37 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32901 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0DJQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e3xunQG0EP2IG83y98cGUTs9fEdGXrnifIIEjWAN62DiYEP/GDGm+sMf4JNPbm/I4D
         6bWISwR/kUu0PxYc7emkzZthqgyIoAY7vfLACf3hon6N6E6XRHdDs1vmi4L+vj+gS5YX
         7f2pcbBcNe7amFhOSGe4y9U3lhGQhPWzSpj2Y=
Date: Sat, 10 Apr 2010 18:35:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] random: Forbid llseek on random chardev
Message-ID: <20100410163529.GI5204@nowhere>
References: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com> <1270916750.28124.23.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270916750.28124.23.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 11:25:50AM -0500, Matt Mackall wrote:
> On Sat, 2010-04-10 at 16:17 +0200, Frederic Weisbecker wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > Seeking on /dev/random and /dev/urandom is pointless.
> 
> It is indeed pointless, though that doesn't mean no one does it. 
> Forbidding a no-op seems a rather unfriendly way to fix this.


I worried about that too. If you think that could break some user
space apps, we can make it a generic_file_llseek.

 
> > Using generic_file_llseek means we no longer need to
> > take the BKL if anyone tries to seek on these.
> 
> Comment doesn't match the patch?


Oops. I guess the patch has been updated, but not the changelog.

Some background: we are trying to remove the uses of default_llseek
that use the bkl. We started with turning llseek stubs to
generic_file_llseek (or non seekable open in some cases), but we are
hesitating now and think about actually turn all the stubs that
might need the bkl into default_llseek, and fallback to
generic_file_llseek for all other stubs.

Depending on what we do I'll resend you an updated version
of this patch with generic_file_llseek, or I will let the stub
as is.

Thanks.

