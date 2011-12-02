Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1LBXIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:08:38 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:15344
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab1LBXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:08:36 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4ED95A5F.7030309@am.sony.com>
Date: Fri, 2 Dec 2011 15:08:15 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: [RT] sysrq Z: sleeping function called from invalid context
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I get a "sleeping function called from invalid context" when I invoke sysrq Z.

I get this both with CONFIG_MAGIC_SYSRQ_FORCE_PRINTK enabled and disabled.

3.0.12-rt29
ARM Pandaboard

I have not tried this on 3.2-rc4-rt5.

[  900.963226] SysRq : Dump ftrace buffer
[  900.967163] Dumping ftrace buffer:
[  900.970733] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[  900.985137] in_atomic(): 0, irqs_disabled(): 128, pid: 563, name: irq/106-OMAP UA
[  900.992980] 2 locks held by irq/106-OMAP UA/563:
[  900.997833]  #0:  (&port_lock_key){+.+...}, at: [<c02d8b14>] serial_omap_irq+0x4c/0x7dc
[  901.006286]  #1:  (sysrq_key_table_lock){+.+...}, at: [<c02c13a0>] __handle_sysrq+0x20/0x18c
[  901.015167] irq event stamp: 45345
[  901.018737] hardirqs last  enabled at (45344): [<c0482f68>] _raw_spin_unlock_irq+0x24/0x4c
[  901.027435] hardirqs last disabled at (45345): [<c00fb854>] ftrace_dump+0x14/0x23c
[  901.035400] softirqs last  enabled at (0): [<c009dca8>] copy_process+0x364/0xf84
[  901.043182] softirqs last disabled at (0): [<  (null)>]   (null)
[  901.049499] [<c00681b8>] (unwind_backtrace+0x0/0xf0) from [<c04824d0>] (rt_spin_lock+0x24/0x5c)
[  901.058654] [<c04824d0>] (rt_spin_lock+0x24/0x5c) from [<c00f3b34>] (read_buffer_lock+0x4c/0x6c)
[  901.067871] [<c00f3b34>] (read_buffer_lock+0x4c/0x6c) from [<c00f5908>] (ring_buffer_empty_cpu+0x50/0x7c)
[  901.077911] [<c00f5908>] (ring_buffer_empty_cpu+0x50/0x7c) from [<c00fa3cc>] (trace_empty+0x58/0xd8)
[  901.087524] [<c00fa3cc>] (trace_empty+0x58/0xd8) from [<c00fb9f8>] (ftrace_dump+0x1b8/0x23c)
[  901.096374] [<c00fb9f8>] (ftrace_dump+0x1b8/0x23c) from [<c02c1428>] (__handle_sysrq+0xa8/0x18c)
[  901.105621] [<c02c1428>] (__handle_sysrq+0xa8/0x18c) from [<c02d90cc>] (serial_omap_irq+0x604/0x7dc)
[  901.115203] [<c02d90cc>] (serial_omap_irq+0x604/0x7dc) from [<c00eb934>] (irq_forced_thread_fn+0x20/0x40)
[  901.125244] [<c00eb934>] (irq_forced_thread_fn+0x20/0x40) from [<c00eb7dc>] (irq_thread+0x144/0x1e4)
[  901.134887] [<c00eb7dc>] (irq_thread+0x144/0x1e4) from [<c00c094c>] (kthread+0x7c/0x84)
[  901.143310] [<c00c094c>] (kthread+0x7c/0x84) from [<c0061e30>] (kernel_thread_exit+0x0/0x8)
[  901.152496]    (ftrace buffer empty)

-Frank

