Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab0JFW3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:29:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50871 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0JFW3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rSiXQTI7Hlh0ryhtRHiWccXMTAQx/9J3V3YF84I8UyXWREVrhd+obKxw5weq/g+qu2
         P8NYXZHRyqO+dA2Pku2/bnMRrfJglsIcELJJmlPVe94Plg7CBO7qiqKlmjrWydqOgPMW
         JWs3IZ8EDHbfikDp6qmna47/+pEA0dxYGi1Es=
MIME-Version: 1.0
Date: Thu, 7 Oct 2010 01:29:15 +0300
Message-ID: <AANLkTik0q3i9SkydhJFbousVrHbc+eMM2SkaxR4MD41U@mail.gmail.com>
Subject: twl4030 irq crashes
From: Grazvydas Ignotas <notasas@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've pulled today's (20101006) linux-next and twl4030 started crashing
on certain interrupts. twl4030 irq code hasn't changed so it's
probably genirq's fault:

[    0.889739] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    0.898193] pgd = c0004000
[    0.901000] [00000000] *pgd=00000000
[    0.904754] Internal error: Oops: 80000005 [#1]
[    0.909484] last sysfs file:
[    0.912567] Modules linked in:
[    0.915771] CPU: 0    Not tainted
(2.6.36-rc6-next-20101006-00001-g766a681-dirty #205)
[    0.924133] PC is at 0x0
[    0.926788] LR is at handle_edge_irq+0x84/0x14c
[    0.931518] pc : [<00000000>]    lr : [<c0077244>]    psr: a0000093
[    0.931549] sp : cf8a5f80  ip : 00000000  fp : 00000000
[    0.943511] r10: 00000000  r9 : 00000000  r8 : cf897f80
[    0.948974] r7 : c0230d6c  r6 : 0000017a  r5 : 00000004  r4 : c03060c8
[    0.955810] r3 : c030d530  r2 : c031d36c  r1 : 00020003  r0 : c03060c8
[    0.962615] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    0.970336] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    0.976348] Process twl4030-irq (pid: 137, stack limit = 0xcf8a42f0)
[    0.982971] Stack: (0xcf8a5f80 to 0xcf8a6000)
[    0.987548] 5f80: 0000017a 00000004 00000002 c015779c 00000175
00000004 00000175 00000000
[    0.996093] 5fa0: 00000007 c015759c 00000000 c0157690 00000007
013071d0 cf8a5fd4 cf81bd20
[    1.004638] 5fc0: 00000007 c006155c c0030078 00000000 00000007
00000000 cf8a5fd8 cf8a5fd8
[    1.013183] 5fe0: 00000000 cf81bd20 c00614d8 c0030078 00000013
c0030078 00000000 00000000
[    1.021759] [<c0077244>] (handle_edge_irq+0x84/0x14c) from
[<c015779c>] (handle_twl4030_sih+0xa0/0xd4)
[    1.031494] [<c015779c>] (handle_twl4030_sih+0xa0/0xd4) from
[<c0157690>] (twl4030_irq_thread+0xf4/0x144)
[    1.041503] [<c0157690>] (twl4030_irq_thread+0xf4/0x144) from
[<c006155c>] (kthread+0x84/0x8c)
[    1.050537] [<c006155c>] (kthread+0x84/0x8c) from [<c0030078>]
(kernel_thread_exit+0x0/0x8)
[    1.059265] Code: bad PC value
