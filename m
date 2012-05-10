Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab2EJRaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:30:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42867 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2EJRaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
Date: Thu, 10 May 2012 10:30:13 -0700
X-Google-Sender-Auth: dTacvQKLBVuY4wq6TS1YjgMinnE
Message-ID: <CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        cmetcalf@tilera.com, tony.luck@intel.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:29 AM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  cb83b629bae0327cf9f44f096adc38d150ceb913
> Gitweb:     http://git.kernel.org/tip/cb83b629bae0327cf9f44f096adc38d150ceb913
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 17 Apr 2012 15:49:36 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 9 May 2012 15:00:55 +0200
>
> sched/numa: Rewrite the CONFIG_NUMA sched domain support
>
> The current code groups up to 16 nodes in a level and then puts an
> ALLNODES domain spanning the entire tree on top of that. This doesn't
> reflect the numa topology and esp for the smaller not-fully-connected
> machines out there today this might make a difference.
>
> Therefore, build a proper numa topology based on node_distance().
>
> Since there's no fixed numa layers anymore, the static SD_NODE_INIT
> and SD_ALLNODES_INIT aren't usable anymore, the new code tries to
> construct something similar and scales some values either on the
> number of cpus in the domain and/or the node_distance() ratio.
>


not sure if this one or other is related....

got this from 8 socket Nehalem-ex box.

[   25.549259] mtrr_aps_init() done
[   25.554298] ------------[ cut here ]------------
[   25.554549] WARNING: at kernel/sched/core.c:6086
build_sched_domains+0x1a9/0x2d0()
[   25.565131] Hardware name: unknown
[   25.565318] Modules linked in:
[   25.584922] Pid: 1, comm: swapper/0 Not tainted
3.4.0-rc6-yh-03548-gecc3211-dirty #312
[   25.585308] Call Trace:
[   25.585464]  [<ffffffff8106a7d1>] warn_slowpath_common+0x83/0x9b
[   25.605128]  [<ffffffff8106a803>] warn_slowpath_null+0x1a/0x1c
[   25.624828]  [<ffffffff81097628>] build_sched_domains+0x1a9/0x2d0
[   25.625154]  [<ffffffff8113db34>] ? __kmalloc+0x82/0x15c
[   25.644820]  [<ffffffff828e9151>] sched_init_smp+0x7f/0x194
[   25.645080]  [<ffffffff828d0fdc>] kernel_init+0xa7/0x19f
[   25.664792]  [<ffffffff81dd0954>] kernel_thread_helper+0x4/0x10
[   25.665094]  [<ffffffff81dc8a59>] ? retint_restore_args+0xe/0xe
[   25.684762]  [<ffffffff828d0f35>] ? do_initcalls+0xc9/0xc9
[   25.685019]  [<ffffffff81dd0950>] ? gs_change+0xb/0xb
[   25.704713] ---[ end trace 5003353dd8ff0030 ]---
[   25.704967] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000020
[   25.724721] IP: [<ffffffff813cf408>] __bitmap_weight+0x1a/0x67
[   25.725011] PGD 0
[   25.725107] Oops: 0000 [#1] SMP
[   25.749960] CPU 0
[   25.750088] Modules linked in:
[   25.750224]
[   25.750301] Pid: 1, comm: swapper/0 Tainted: G        W
3.4.0-rc6-yh-03548-gecc3211-dirty #312 Oracle Corporation  unknown
  /
[   25.765035] RIP: 0010:[<ffffffff813cf408>]  [<ffffffff813cf408>]
__bitmap_weight+0x1a/0x67
[   25.784842] RSP: 0018:ffff8810374c1e70  EFLAGS: 00010206
[   25.804557] RAX: 0000000000000003 RBX: 000000000000007f RCX: 0000000000000003
[   25.804940] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000000000020
[   25.824665] RBP: ffff8810374c1e70 R08: 0000000000000020 R09: 0000000000000000
[   25.844504] R10: 0000000000000000 R11: 0000000000000082 R12: ffff8880373bcfc0
[   25.844882] R13: 0000000000000000 R14: ffff8880373eae00 R15: fffffffffffffc08
[   25.864512] FS:  0000000000000000(0000) GS:ffff88103de00000(0000)
knlGS:0000000000000000
[   25.884400] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   25.884695] CR2: 0000000000000020 CR3: 00000000025af000 CR4: 00000000000007f0
[   25.904389] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   25.904753] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   25.924501] Process swapper/0 (pid: 1, threadinfo ffff8810374c0000,
task ffff8810374b8000)
[   25.944730] Stack:
[   25.944856]  ffff8810374c1ee0 ffffffff81097636 ffff8810374c1ed0
ffffffff8113db34
[   25.964506]  2222222222222222 ffff8880373ebe00 00000000001d6828
ffff88803706a000
[   25.964870]  ffff8810374b85c8 ffffffff829c73f8 ffff8810374b85c8
00000000000000ff
[   25.984495] Call Trace:
[   25.984624]  [<ffffffff81097636>] build_sched_domains+0x1b7/0x2d0
[   26.004343]  [<ffffffff8113db34>] ? __kmalloc+0x82/0x15c
[   26.004607]  [<ffffffff828e9151>] sched_init_smp+0x7f/0x194
[   26.024288]  [<ffffffff828d0fdc>] kernel_init+0xa7/0x19f
[   26.024560]  [<ffffffff81dd0954>] kernel_thread_helper+0x4/0x10
[   26.044222]  [<ffffffff81dc8a59>] ? retint_restore_args+0xe/0xe
[   26.044539]  [<ffffffff828d0f35>] ? do_initcalls+0xc9/0xc9
[   26.064134]  [<ffffffff81dd0950>] ? gs_change+0xb/0xb
[   26.064410] Code: 48 8b 0c d6 48 89 0c d7 48 ff c2 39 d0 7f f1 5d
c3 89 f0 b9 40 00 00 00 55 99 49 89 f8 45 31 c9 f7 f9 48 89 e5 31 d2
89 c1 eb 0f <49> 8b 3c d0 48 ff c2 f3 48 0f b8 c7 41 01 c1 39 d1 7f ed
45 31
[   26.104070] RIP  [<ffffffff813cf408>] __bitmap_weight+0x1a/0x67
[   26.123783]  RSP <ffff8810374c1e70>
[   26.123947] CR2: 0000000000000020
[   26.124143] ---[ end trace 5003353dd8ff0031 ]---
[   26.143813] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000009
