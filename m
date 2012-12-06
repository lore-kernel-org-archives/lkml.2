Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2LFOle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:41:34 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:40370 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab2LFOlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:41:32 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 09:41:32 EST
From: Tim Sander <tstone@iss.tu-darmstadt.de>
Organization: Integrierte Schaltungen und Systeme
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
Date: Thu, 6 Dec 2012 15:35:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1212051659160.2701@ionos>
In-Reply-To: <alpine.LFD.2.02.1212051659160.2701@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212061535.37585.tstone@iss.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.12.6.142718
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas
> I'm pleased to announce the 3.6.9-rt21 release. 3.6.7-rt18, 3.6.8-rt19
> and 3.6.9-rt20 are not announced updates to the respective 3.6.y
> stable releases without any RT changes
There is some progress here. It boots but sometimes i see the backtrace below.

Also: Has s.th. changed in respect to the modules. I have one module wich goes on an 
endless interrupt loop freezing the device. The driver works fine for 3.0  - 3.4 preempt 
rt kernels? This is a miscdev based driver. If someone is interested i can post the source 
over here. But unfortunatly i have not figured out why this thing goes to an endless interrupt.
The identical driver works flawless on 3.4.

As always i have some platform adaptation code applied but nothing serious/different from the 3.4 patches which work fine.

Backtrace: 
[<c00114ec>] (dump_backtrace+0x0/0x110) from [<c029732c>] (dump_stack+0x18/0x1c)
 r6:c0327ca9 r5:00000da5 r4:00000000 r3:c7846080
[<c0297314>] (dump_stack+0x0/0x1c) from [<c001b910>] (warn_slowpath_common+0x54/0x6c)
[<c001b8bc>] (warn_slowpath_common+0x0/0x6c) from [<c001b94c>] (warn_slowpath_null+0x24/0x2c)
 r8:c03b0bc8 r7:c03c5f38 r6:c784e000 r5:60000013 r4:00000000
r3:00000009
[<c001b928>] (warn_slowpath_null+0x0/0x2c) from [<c00533cc>] (check_flags+0xcc/0x12c)
[<c0053300>] (check_flags+0x0/0x12c) from [<c0054ef0>] (lock_is_held+0x3c/0xb4)
[<c0054eb4>] (lock_is_held+0x0/0xb4) from [<c0043ff0>] (__might_sleep+0x40/0x1d0)
 r8:c03b2440 r7:c03c5f38 r6:00000000 r5:c0327ce1 r4:00000481
r3:00000000
[<c0043fb0>] (__might_sleep+0x0/0x1d0) from [<c0299228>] (rt_mutex_lock+0x20/0x40)
 r7:c784ff24 r6:c08c0e80 r5:c784e000 r4:c784ff20
[<c0299208>] (rt_mutex_lock+0x0/0x40) from [<c0068a54>] (rcu_kthread+0x100/0x198)
 r4:c784ff20 r3:c784ff40
[<c0068954>] (rcu_kthread+0x0/0x198) from [<c003be14>] (kthread+0x90/0x9c)
[<c003bd84>] (kthread+0x0/0x9c) from [<c00218e8>] (do_exit+0x0/0x2f0)
 r7:00000013 r6:c00218e8 r5:c003bd84 r4:c782becc
---[ end trace 0000000000000002 ]---
possible reason: unannotated irqs-on.
irq event stamp: 87282
hardirqs last  enabled at (87281): [<c029a1a8>] _raw_spin_unlock_irqrestore+0x44/0x80
hardirqs last disabled at (87282): [<c00541c8>] debug_check_no_locks_freed+0x44/0x154
softirqs last  enabled at (0): [<c001a2fc>] copy_process+0x1f4/0xb78
softirqs last disabled at (0): [<  (null)>]   (null)

Best regards
Tim
