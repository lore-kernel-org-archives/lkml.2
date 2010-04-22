Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0DVD3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 23:29:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60953 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab0DVD3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:29:51 -0400
Message-ID: <4BCFC31B.5000706@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 11:31:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [BUG] a WARNING and a BUG from kernel/lockdep.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is caused by commit bd6d29c25bb1a24a4c160ec5de43e0004e01f72b
("lockstat: Make lockstat counting per cpu")

?


============================


------------[ cut here ]------------                 
WARNING: at kernel/lockdep.c:2301 trace_hardirqs_on_caller+0x210/0x220()
Hardware name: Aspire SA85                                              
Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath linear ppdev pcspkr parport_pc parport r8169 mii ata_generic pata_acpi sata_sis pata_sis [last unloaded: scsi_wait_scan]
Pid: 2452, comm: java Not tainted 2.6.34-rc5-tip+ #6
Call Trace:
 [<c083c276>] ? printk+0x1d/0x1f
 [<c044c1e2>] warn_slowpath_common+0x72/0xa0
 [<c0482500>] ? trace_hardirqs_on_caller+0x210/0x220
 [<c0482500>] ? trace_hardirqs_on_caller+0x210/0x220
 [<c042a52c>] ? __bad_area_nosemaphore+0x2c/0x130
 [<c044c22a>] warn_slowpath_null+0x1a/0x20
 [<c0482500>] trace_hardirqs_on_caller+0x210/0x220
 [<c048251b>] trace_hardirqs_on+0xb/0x10
 [<c042a52c>] __bad_area_nosemaphore+0x2c/0x130
 [<c042a67e>] ? __bad_area+0x2e/0x50
 [<c042a68f>] __bad_area+0x3f/0x50
 [<c0842bd0>] ? do_page_fault+0x0/0x500
 [<c042a6d7>] bad_area_access_error+0x17/0x20
 [<c0842df9>] do_page_fault+0x229/0x500
 [<c084074f>] ? error_code+0x67/0x70
 [<c047e854>] ? trace_hardirqs_off_caller+0x74/0x130
 [<c0842bd0>] ? do_page_fault+0x0/0x500
 [<c0840753>] error_code+0x6b/0x70
 [<c0842bd0>] ? do_page_fault+0x0/0x500
---[ end trace 93d0036abe3ab514 ]---
BUG: using smp_processor_id() in preemptible [00000000] code: java/2452
caller is trace_hardirqs_on_caller+0x18d/0x220
Pid: 2452, comm: java Tainted: G        W  2.6.34-rc5-tip+ #6
Call Trace:
 [<c083c276>] ? printk+0x1d/0x1f
 [<c0627160>] debug_smp_processor_id+0xc0/0xd0
 [<c042a52c>] ? __bad_area_nosemaphore+0x2c/0x130
 [<c048247d>] trace_hardirqs_on_caller+0x18d/0x220
 [<c048251b>] trace_hardirqs_on+0xb/0x10
 [<c042a52c>] __bad_area_nosemaphore+0x2c/0x130
 [<c042a67e>] ? __bad_area+0x2e/0x50
 [<c042a68f>] __bad_area+0x3f/0x50
 [<c0842bd0>] ? do_page_fault+0x0/0x500
 [<c042a6d7>] bad_area_access_error+0x17/0x20
 [<c0842df9>] do_page_fault+0x229/0x500
 [<c084074f>] ? error_code+0x67/0x70
 [<c047e854>] ? trace_hardirqs_off_caller+0x74/0x130
 [<c0842bd0>] ? do_page_fault+0x0/0x500
 [<c0840753>] error_code+0x6b/0x70
 [<c0842bd0>] ? do_page_fault+0x0/0x500
