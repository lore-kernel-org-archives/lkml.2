Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1IFPu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:50:57 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:59080 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598Ab1IFPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:50:51 -0400
Message-ID: <4E66414E.8060100@blueyonder.co.uk>
Date: Tue, 06 Sep 2011 16:50:38 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.x memleaks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=TwUyvNu_jswA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=dip-b8-1cTEUm6-kft4A:9 a=5rZo7-_p1246QApLr20A:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.0 I have been seeing memleaks, right up to 3.1.0-rc5. This is 
typical.
AMD x86_64, X2, X4's and openSUSE 12.1 Milestones.
unreferenced object 0xffff88022f007000 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88022f007600 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88022f007800 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88022f007a00 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88022f007c00 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88022f007e00 (size 512):
   comm "swapper", pid 1, jiffies 4294667649 (age 18070.657s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
     [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
     [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
     [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
     [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
     [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
     [<ffffffff81c36cca>] kernel_init+0xb8/0x159
     [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff
****** the rest truncated *************
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks
