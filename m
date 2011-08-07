Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1HGTvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 15:51:39 -0400
Received: from lucidpixels.com ([72.73.18.11]:60177 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1HGTvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 15:51:37 -0400
Date: Sun, 7 Aug 2011 15:51:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 3.0.0: BUG: using smp_processor_id() in preemptible [00000000]
 code: Xorg/2334
Message-ID: <alpine.DEB.2.02.1108071547530.24247@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running kernel 3.0.0 (with proprietary fglrx driver), is there a open 
source driver on the ATI side of things that supports this card similar to 
nouveau for nvidia cards if that is the root cause of the problem below?
Or is there a mailing list to discuss this type of problem w/fglrx module 
loaded?

01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility 
Radeon HD 4200]

When this occurs (or sometime after) the wireless network connection stops 
working:

[   34.981965] [fglrx] ATIF platform detected with notification ID: 0x81
[   35.093146] [fglrx] GART Table is not in FRAME_BUFFER range 
[   35.093327] [fglrx] Could not enable MSI; System prevented initialization
[   35.093523] BUG: using smp_processor_id() in preemptible [00000000] code: Xor
g/2334
[   35.093557] caller is kas_GetExecutionLevel+0xd/0x20 [fglrx]
[   35.093560] Pid: 2334, comm: Xorg Tainted: P            3.0.0 #3
[   35.093562] Call Trace:
[   35.093570]  [<ffffffff812ec5f6>] ? debug_smp_processor_id+0xd6/0xf0
[   35.093591]  [<ffffffffa01fe42d>] ? kas_GetExecutionLevel+0xd/0x20 [fglrx]
[   35.093612]  [<ffffffffa01fe4a9>] ? kas_spin_lock+0x9/0xd0 [fglrx]
[   35.093635]  [<ffffffffa0202c66>] ? KAS_InterlockedList_InsertAtTail+0x76/0x1
60 [fglrx]
[   35.093663]  [<ffffffffa022d4e2>] ? firegl_trace+0x72/0x1e0 [fglrx]
[   35.093688]  [<ffffffffa0218e43>] ? MCIL_InterlockedList+0x193/0x2a0 [fglrx]
[   35.093721]  [<ffffffffa02ce7b6>] ? FIFO_Queue_Initialize+0xe6/0x100 [fglrx]
[   35.093746]  [<ffffffffa0211cb5>] ? fireglPcsCommand+0xa5/0x140 [fglrx]
[   35.093771]  [<ffffffffa0216e39>] ? MCIL_GetRegistrykey+0x269/0x760 [fglrx]
[   35.093801]  [<ffffffffa02dc362>] ? AvailableCallbacksQueue_Initialize+0x52/0
x70 [fglrx]
[   35.093830]  [<ffffffffa02de9cd>] ? InitializeExtension+0x12d/0x280 [fglrx]
[   35.093858]  [<ffffffffa02df0e8>] ? InitializeInterrupts+0x38/0x60 [fglrx]
[   35.093890]  [<ffffffffa02cd12d>] ? IRQMGR_InitializeIRQMGR+0xfd/0x110 [fglrx
]
[   35.093917]  [<ffffffffa021c6df>] ? IRQMGR_initialize+0x1ef/0x380 [fglrx]
[   35.093943]  [<ffffffffa021c497>] ? IRQMGR_alloc_context+0xb7/0x110 [fglrx]
[   35.093969]  [<ffffffffa021b8d2>] ? irqmgr_wrap_initialize+0x22/0xb0 [fglrx]
[   35.093994]  [<ffffffffa021b1f4>] ? firegl_interrupt_control+0x174/0x1a0 [fgl
rx]
[   35.093999]  [<ffffffff81043c39>] ? ns_capable+0x29/0x50
[   35.094044]  [<ffffffffa021b080>] ? firegl_enable_hifreq_interrupt+0x100/0x10
0 [fglrx]
[   35.094072]  [<ffffffffa020cf98>] ? firegl_ioctl+0x1e8/0x250 [fglrx]
[   35.094098]  [<ffffffffa01fea19>] ? ip_firegl_unlocked_ioctl+0x9/0x10 [fglrx]
[   35.094105]  [<ffffffff810ce8ee>] ? do_vfs_ioctl+0x8e/0x4f0
[   35.094112]  [<ffffffff810ced99>] ? sys_ioctl+0x49/0x90
[   35.094119]  [<ffffffff810be847>] ? sys_write+0x47/0x90
[   35.094126]  [<ffffffff8165b67b>] ? system_call_fastpath+0x16/0x1b

Justin.

