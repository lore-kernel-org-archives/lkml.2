Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2LAVoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 16:44:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53262 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2LAVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 16:44:43 -0500
Date: Sat, 1 Dec 2012 22:44:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
Message-ID: <20121201214438.GA6544@gmail.com>
References: <20121201111609.GA18679@gmail.com>
 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Dec 1, 2012 at 3:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please [RFC] pull the latest sched-urgent-for-linus git tree
> > from:
> 
> No. That patch is braindead. I wouldn't pull it even if it 
> wasn't this late.
> 
> Why the hell leave a read-only 'sched_autogroup_enabled' proc 
> file?
>
> What the f*ck is the point? It looks like the flag still 
> exists (we test it), but now there's no point to it, since you 
> can't change it.
> 
> What am I missing?

You are not missing anything. That flag is my fault not Mike's: 
I booted the initial version of that patch but was unsure 
whether autogroups was enabled - it's a pretty transparent 
feature. So I figured that having that flag (but readonly) would 
give us this information definitely.

So I suggested to Mike to keep that flag so that user-space is 
informed that autogroups is enabled. It seemed like a cute 
usability twist at that time, and there's existing precedent for 
it in /proc, but now I'm not so sure anymore...

Should we use some other file for that - or no file at all and 
just emit a bootup printk for kernel hackers with a short 
attention span?

Thanks,

	Ingo
