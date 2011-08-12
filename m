Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1HLIDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:03:43 -0400
Received: from lucidpixels.com ([72.73.18.11]:57570 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1HLIDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:03:34 -0400
Date: Fri, 12 Aug 2011 04:03:33 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 3.0: BUG: soft lockup - CPU#7 stuck for 23s!
Message-ID: <alpine.DEB.2.02.1108120401160.21591@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can anyone explain what is the cause of this problem?

  75 [330509.718763] Call Trace:
  76 [330509.718771]  [<ffffffff81089e15>] ? pagevec_lookup+0x15/0x20
  77 [330509.718776]  [<ffffffff8108b905>] ? invalidate_mapping_pages+0x55/0x130
  78 [330509.718784]  [<ffffffff810d6835>] ? shrink_icache_memory+0x2c5/0x310
  79 [330509.718788]  [<ffffffff8108c254>] ? shrink_slab+0x104/0x170
  80 [330509.718793]  [<ffffffff8108eda2>] ? balance_pgdat+0x492/0x600
  81 [330509.718798]  [<ffffffff8108efbc>] ? kswapd+0xac/0x250
  82 [330509.718803]  [<ffffffff81050fd0>] ? abort_exclusive_wait+0xb0/0xb0
  83 [330509.718807]  [<ffffffff8108ef10>] ? balance_pgdat+0x600/0x600
  84 [330509.718811]  [<ffffffff8105082e>] ? kthread+0x7e/0x90
  85 [330509.718818]  [<ffffffff815b4e14>] ? kernel_thread_helper+0x4/0x10
  86 [330509.718822]  [<ffffffff810507b0>] ? kthread_worker_fn+0x120/0x120
  87 [330509.718825]  [<ffffffff815b4e10>] ? gs_change+0xb/0xb

Also:

[330514.882885] Call Trace:
[330514.882894]  [<ffffffff8147de53>] ? cpuidle_idle_call+0x73/0xe0
[330514.882901]  [<ffffffff810007e6>] ? cpu_idle+0x56/0xb0
[330514.882906] Code: 28 e0 ff ff 83 e2 08 75 22 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 48 89 e8 0f 01 c9 <e8> cd da d3 ff 4c 29 e0 48 89 c7 e8 92 fa d1 ff 48 69 e8 40 42
[330514.882972] Call Trace:
[330514.882979]  [<ffffffff8147de53>] ? cpuidle_idle_call+0x73/0xe0
[330514.882992]  [<ffffffff810007e6>] ? cpu_idle+0x56/0xb0
[330514.883001] NMI backtrace for cpu 19
[330514.883008] CPU 19

Full output here:

http://home.comcast.net/~jpiszcz/20110812/3.0-error.txt

Justin.

