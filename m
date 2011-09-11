Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473Ab1IKWRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 18:17:22 -0400
Received: from lucidpixels.com ([72.73.18.11]:46606 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1IKWRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 18:17:21 -0400
Date: Sun, 11 Sep 2011 18:17:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
Message-ID: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 3.0.1 now and all options compiled in and threadirqs removed, I get 
the same error this user is seeing:
http://www.gossamer-threads.com/lists/linux/kernel/1424997

E.g.,

Sep 11 17:48:26 p34 kernel: [25507.537996] Call Trace:
Sep 11 17:48:26 p34 kernel: [25507.538000]  [<ffffffff8108538d>] pagevec_lookup+0x1d/0x30
Sep 11 17:48:26 p34 kernel: [25507.538004]  [<ffffffff81085a8f>] invalidate_mapping_pages+0x5f/0x170
Sep 11 17:48:26 p34 kernel: [25507.538009]  [<ffffffff810d0ba5>] shrink_icache_memory+0x2d5/0x320
Sep 11 17:48:26 p34 kernel: [25507.538013]  [<ffffffff810868fd>] shrink_slab+0x11d/0x190
Sep 11 17:48:26 p34 kernel: [25507.538016]  [<ffffffff81089562>] balance_pgdat+0x4f2/0x680
Sep 11 17:48:26 p34 kernel: [25507.538020]  [<ffffffff810897a3>] kswapd+0xb3/0x250
Sep 11 17:48:26 p34 kernel: [25507.538023]  [<ffffffff8104fd00>] ? abort_exclusive_wait+0xb0/0xb0
Sep 11 17:48:26 p34 kernel: [25507.538027]  [<ffffffff810896f0>] ? balance_pgdat+0x680/0x680
Sep 11 17:48:26 p34 kernel: [25507.538030]  [<ffffffff8104f2b7>] kthread+0x87/0x90
Sep 11 17:48:26 p34 kernel: [25507.538034]  [<ffffffff8163bd94>] kernel_thread_helper+0x4/0x10
Sep 11 17:48:26 p34 kernel: [25507.538038]  [<ffffffff8104f230>] ? kthread_flush_work_fn+0x10/0x10
Sep 11 17:48:26 p34 kernel: [25507.538043]  [<ffffffff8163bd90>] ? gs_change+0xb/0xb

Does anyone know what could be causing this?

Justin.

