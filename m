Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1HARaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:30:00 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:37955 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379Ab1HAR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:29:55 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Aug 2011 13:29:55 EDT
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: shm updates broke UML
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 01 Aug 2011 19:19:19 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Richard Weinberger <richard@nod.at>, <serge.hallyn@canonical.com>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <toralf.foerster@gmx.de>
Organization: ARM Ltd
In-Reply-To: <20110801171042.GA25954@albatros>
References: <201108011541.59640.richard@nod.at> <20110801134911.GA11705@albatros> <43e4e9e98b32d3d3eb06ab837a019ad8@localhost> <20110801171042.GA25954@albatros>
Message-ID: <08cf4697685ecd9bcb7e4eefe516f2ee@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: segoon@openwall.com, richard@nod.at, serge.hallyn@canonical.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 1 Aug 2011 21:10:42 +0400, Vasiliy Kulikov <segoon@openwall.com>
wrote:
> On Mon, Aug 01, 2011 at 18:01 +0200, Marc Zyngier wrote:
>> It also breaks ARM (at least 11MPCore and Cortex A9).
>> The same workaround gets the kernel booting again.
> 
> Can you please apply this patch and show the output? 
> I suppose all numbers will be nonNULL and the last is NULL.

Here you go (sorry about the line wrapping, damned webmail...):

Calibrating local timer... 104.99MHz.
CPU1: Booted secondary processor
CPU1: Unknown IPI message 0x1
CPU2: Booted secondary processor
CPU2: Unknown IPI message 0x1
CPU3: Booted secondary processor
CPU3: Unknown IPI message 0x1
Brought up 4 CPUs
SMP: Total of 4 processors activated (333.41 BogoMIPS).
ns = c0447474, ids = c04474d0
ns = c0447474, ids = c04474d0
wait_list = c04474e0
next =   (null)
Unable to handle kernel NULL pointer dereference at virtual address
00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1] SMP
Modules linked in:
CPU: 3    Not tainted  (3.0.0-next-20110801+ #808)
PC is at __down_write_nested+0x88/0xe0
LR is at __down_write_nested+0x18/0xe0
pc : [<c0320090>]    lr : [<c0320020>]    psr: 60000093
sp : df8d1f68  ip : 00000000  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : c04474dc
r7 : c04474d8  r6 : 00000000  r5 : 00000002  r4 : df884380
r3 : df884388  r2 : 00000000  r1 : 60000013  r0 : c04474e0
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5787f  Table: 7000400a  DAC: 00000015
Process kworker/u:0 (pid: 19, stack limit = 0xdf8d0270)
Stack: (0xdf8d1f68 to 0xdf8d2000)
1f60:                   c04474e0 c031dae0 df884380 00000002 c0447474
c04474d8
1f80: 00000000 00000000 df8b0200 c015d9e4 df884380 00000000 00000000
c002e550
1fa0: 00000000 00000000 df8d0000 00000001 00000000 00000000 00000000
00000000
1fc0: 00000000 df823a00 df8d2000 fffffffe 00000013 00000000 00000000
00000000
1fe0: 00000000 c003eaac df823a00 c003e970 c000f630 c000f630 55555555
55555555
[<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015d9e4>]
(exit_shm+0x48/0x8c)
[<c015d9e4>] (exit_shm+0x48/0x8c) from [<c002e550>] (do_exit+0x59c/0x750)
[<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>]
(____call_usermodehelper+0x13c/0x154)
[<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>]
(kernel_thread_exit+0x0/0x8)
Code: 1afffffa e597c00c e58d0000 e587d00c (e58cd000) 
---[ end trace 1b75b31a2719ed1c ]---
Fixing recursive fault but reboot is needed!
NET: Registered protocol family 16
ns = c0447474, ids = c04474d0
wait_list = c04474e0
next =   (null)
ns = c0447474, ids = c04474d0
wait_list = c04474e0
next =   (null)
ns = c0447474, ids = c04474d0
wait_list = c04474e0
next =   (null)
wait_list = c04474e0
next =   (null)

-- 
Fast, cheap, reliable. Pick two.
