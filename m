Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1FGDqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1FGDqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:46:33 -0400
Date: Mon, 6 Jun 2011 23:46:17 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: random hangs during boot in 3.0-rc
Message-ID: <20110607034617.GA27980@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two machines that occasionally (like 1 in 10 boots or so) hang solid
during boot-up.  Happens in different places, but usually either when loading
the microcode driver, or while doing a fsck.

I did a bisect which took a *long* time, since I booted each kernel 10 times
before pronouncing it 'good'. Once it fingered the bad commit, I started over,
and arrived at the same conclusion a second time.

But the actual commit is a merge commit.  What now ?

commit 42ac9e87fdd89b77fa2ca0a5226023c1c2d83226
Merge: 057f3fa f0e615c
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Apr 21 11:39:21 2011 +0200

    Merge commit 'v2.6.39-rc4' into sched/core
    
    Merge reason: Pick up upstream fixes.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


It's possible I just didn't get 'lucky' and marked something as good,
when it wouldn't have triggered until the 11th boot, which is why I did that
second bisect run.  Should I bother doing a 3rd try ?

The kernels have a bunch of debug options turned on, but I don't get anything
out of the machine at all, it's just wedged solid.

The machines I'm seeing this on are a quad-core AMD Phenom, and a Dual core2duo,
so quite disparate hardware. (And making me believe it's too coincidental to be a
hardware problem).

Anyone else seeing anything like this ?

	Dave


git bisect start
# bad: [d762f4383100c2a87b1a3f2d678cd3b5425655b4] Merge branch 'sh-latest' of git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6
git bisect bad d762f4383100c2a87b1a3f2d678cd3b5425655b4
# good: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
git bisect good 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
# bad: [052497553e5dedc04c43800820c1d5788201cc71] Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 052497553e5dedc04c43800820c1d5788201cc71
# good: [2142c131a3e290ae350f8a0b0d354c0585a96df1] net: convert to new cpumask API
git bisect good 2142c131a3e290ae350f8a0b0d354c0585a96df1
# bad: [a2d063ac216c1618bfc2b4d40b7176adffa63511] extable, core_kernel_data(): Make sure all archs define _sdata
git bisect bad a2d063ac216c1618bfc2b4d40b7176adffa63511
# good: [df48d8716eab9608fe93924e4ae06ff110e8674f] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good df48d8716eab9608fe93924e4ae06ff110e8674f
# bad: [13588209aa90d9c8e502750fc86160314555612f] Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 13588209aa90d9c8e502750fc86160314555612f
# bad: [7e6628e4bcb3b3546c625ec63ca724f28ab14f0c] Merge branch 'timers-clockevents-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 7e6628e4bcb3b3546c625ec63ca724f28ab14f0c
# good: [6ddafdaab3f809b110ada253d2f2d4910ebd3ac5] Merge branch 'sched/locking' into sched/core
git bisect good 6ddafdaab3f809b110ada253d2f2d4910ebd3ac5
# good: [61ee9a4ba05f0a4163d43a33dee7a0651e080b98] x86: Convert PIT to clockevents_config_and_register()
git bisect good 61ee9a4ba05f0a4163d43a33dee7a0651e080b98
# bad: [7142d17e8f935fa842e9f6eece2281b6d41625d6] sched: Shorten the construction of the span cpu mask of sched domain
git bisect bad 7142d17e8f935fa842e9f6eece2281b6d41625d6
# bad: [d3bf52e998056a6002b2aecfe1d25486376382ac] sched: Remove obsolete comment from scheduler_tick()
git bisect bad d3bf52e998056a6002b2aecfe1d25486376382ac
# good: [2f36825b176f67e5c5228aa33d828bc39718811f] sched: Next buddy hint on sleep and preempt path
git bisect good 2f36825b176f67e5c5228aa33d828bc39718811f
# bad: [42ac9e87fdd89b77fa2ca0a5226023c1c2d83226] Merge commit 'v2.6.39-rc4' into sched/core
git bisect bad 42ac9e87fdd89b77fa2ca0a5226023c1c2d83226
# good: [057f3fadb347e9c51b07e1b277bbdda79f976768] sched: Fix sched_domain iterations vs. RCU
git bisect good 057f3fadb347e9c51b07e1b277bbdda79f976768

