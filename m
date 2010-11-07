Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0KGL4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:56:51 -0500
Received: from 1wt.eu ([62.212.114.60]:47134 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0KGL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:56:50 -0500
Date: Sun, 7 Nov 2010 12:56:26 +0100
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
Message-ID: <20101107115626.GX4627@1wt.eu>
References: <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107112709.GA2634@elte.hu> <20101107114156.GV4627@1wt.eu> <20101107114756.GB3759@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107114756.GB3759@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 12:47:56PM +0100, Ingo Molnar wrote:
> I did read it and saw no valid counter-examples. You mentioned this one:
> 
>  > Take the splice() data corruption bug for instance. I believe it was fixed in 
>  > 2.6.26 or 2.6.27 and backported late in the 2.6.25.X stable branch. Due to this, 
>  > without knowing the kernel version, the user can't know whether it's safe to use 
>  > splice() or not. I'm particularly aware of this one because I got quite a bunch 
>  > of questions from users on this subject. But certainly there are a bunch of other 
>  > ones.
> 
> That example is entirely bogus. The correct answer to a buggy, data-corrupting 
> kernel is a fixed kernel. No ifs and when. No version checks in user-space. If 
> user-space ever works around a bug in that fashion it's entirely broken and 
> _deserves_ to be further broken via version fuzzing.

It's not working around a bug, it's that using splice() instead of
recv()+send() brings an important speed up in some environments, and that
it is suggested to make use of it when possible, except on buggy kernels.
Some user-space code simply have a tunable to enable it or not.

> Do you know of a single such actual vmsplice() version check example in user-space, 
> or have you just made it up?

I was not speaking about vmsplice() but about splice(). And yes it's a real
world example. Haproxy makes use of it when the option is specified. And it
will never enable it automatically due to that nasty data corruption bug
that cannot be detected. Only the user can run "uname -a" and compare with
his distro's fixes (or mainline kernel fixes) and know what to do. Once again
it's just *one* example. A version is beforeall an indication of features and
bugs status.

It's precisely because you're making a special case of the security bug that
you want to hide bugs from user-space by cheating on version.

Willy

