Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1AYNnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:43:12 -0500
Received: from www.tglx.de ([62.245.132.106]:57317 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1AYNnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:43:11 -0500
Date: Tue, 25 Jan 2011 14:42:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Emil Langrock <emil.langrock@gmx.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Recursive deactivation of local bottom halves
In-Reply-To: <201101251405.18157.emil.langrock@gmx.de>
Message-ID: <alpine.LFD.2.00.1101251432210.31804@localhost6.localdomain6>
References: <201101251405.18157.emil.langrock@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Emil Langrock wrote:
> I wanted or more or less had to do following:
> 
> ...
> spin_lock_bh(lock1);
> ....
> 	spin_lock_bh(lock2);
> 	...
> 	spin_unlock_bh(lock2);
> ....
> spin_unlock_bh(lock1);
> ....
> 
> Now some weird behavior were noticed by a second person and he fixed it by 
> removing the _bh from the inner spinlocks. I checked what the difference is 

You're not telling us what kind of weird behaviour was observed and
why the "fix" made it go away. You neither showed the real code and
the "fix", so there is no way to tell what problem you're facing. What
I can tell w/o using a crystal ball is that the "fix" stinks.

> According to http://people.netfilter.org/rusty/unreliable-guides/kernel-
> hacking/routines-softirqs.html it makes no difference how often I use the pair 
> local_bh_disable/local_bh_enable inside local_bh_disable/local_bh_enable. So 
> was this changed?

Nope.

> Can somebody tell me if that is legal or not (on smp and uniprocessor)? And 
> maybe can show me the related source code why is it may or may not be legal?

IANAL, so I can't tell you for sure whether it's legal or not. Though
I'd say it's legal in your jurisdiction. :)

There is no restriction on nesting local_bh_disable/enable as long as
you don't overflow the field width, which is 8 bits and therefor
supports 255 nest levels.

Thanks,

	tglx
