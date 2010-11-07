Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0KGMwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:52:14 -0500
Received: from 1wt.eu ([62.212.114.60]:47169 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0KGMwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:52:13 -0500
Date: Sun, 7 Nov 2010 13:51:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101107125120.GA4627@1wt.eu>
References: <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107112709.GA2634@elte.hu> <20101107114156.GV4627@1wt.eu> <20101107114756.GB3759@elte.hu> <20101107115626.GX4627@1wt.eu> <20101107121235.GA6221@elte.hu> <20101107122227.GY4627@1wt.eu> <20101107123232.GB6512@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107123232.GB6512@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:32:32PM +0100, Ingo Molnar wrote:
> No. The 'exploit honeypot' mechanism i outlined is really simple, and it means what 
> i explained already:
> 
>  - attacker breaks into unprivileged user-space
> 
>  - attacker runs exploit
> 
>  - exploit attempt gets detected by the 'exploit honeypot' kernel code and a 
>    (silent) warning goes to the admin (via a syslog message for example)
> 
>  - attacker only sees that the attack did not succeed
> 
> This makes it _unsafe_ (for many types of attackers) to run an exploit locally.

It's already unsafe and has always been. When running local kernel exploits,
it's common to find lots of segfault traces in dmesg. It's common to hang the
machine (the vmsplice exploit had a 50% failure rate from my tests).

> > That's not much different than trying to fire the exploit itself. [...]
> 
> Erm, the difference is possible _detection_ via a silent alarm.
>
> There's a huge difference between 'attempting an exploit and being caught' and 'not 
> even trying the exploit because based on the kernel version the attacker knows it 
> wont work'.

And there's an even bigger difference between leaving traces of a failed
exploit attempt and successfully getting the exploit to work because the
system is not updated in time. That's been my point since the beginning,
most kernel exploits are run very early when released to the public. So
that's when a simple "uptime" will tell you it's safe to run your exploit.
And if you want to hide the uptime, let's simply check the creation date
of /dev/shm, or that a file you left in /tmp has not been removed by the
admin's scripts which clean that up at boot, etc...

In my opinion this is not efficient at all. Also, I've already been involved
in post-mortem diags on compromised machines. If the intruder is not a known
local user, he does not care at all being caught. Leaving rootkits everywhere
is generally not a problem for them, some don't even take care of clearing
the logs, because they bounced from already compromised systems.

Willy

