Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1KBKSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:18:14 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44512 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab1KBKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:18:12 -0400
From: Luciano Coelho <coelho@ti.com>
To: balbi@ti.com
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: hdrc: fix dependency on USB_GADGET_DUALSPEED in Kconfig
Date: Wed,  2 Nov 2011 12:17:59 +0200
Message-Id: <1320229079-27735-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_MUSB_HDRC depends on USB_GADGET_DUALSPEED.  If HDRC is selected
but DUALSPEED is not, the kernel oopses:

[    3.132781] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    3.141296] pgd = c0004000
[    3.144134] [00000000] *pgd=00000000
[    3.147918] Internal error: Oops: 5 [#1] SMP
[    3.152404] Modules linked in:
[    3.155609] CPU: 0    Not tainted  (3.1.0-rc9-wl+ #417)
[    3.161132] PC is at composite_setup+0x738/0xbb4
[    3.165985] LR is at vprintk+0x400/0x47c
[    3.170135] pc : [<c031df90>]    lr : [<c004c150>]    psr: 60000093
[    3.170135] sp : c065dd50  ip : dfb1f0fc  fp : c065ddbc
[    3.182220] r10: 00000000  r9 : df8fcae8  r8 : df8fcaa0
[    3.187713] r7 : 00000000  r6 : df8eaa20  r5 : dfae8ea0  r4 : 00000000
[    3.194580] r3 : df8fcae8  r2 : 00010002  r1 : c065dc40  r0 : 00000047
[    3.201446] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    3.209228] Control: 10c53c7d  Table: 8000404a  DAC: 00000015
[    3.215270] Process swapper (pid: 0, stack limit = 0xc065c2f8)
[    3.221405] Stack: (0xc065dd50 to 0xc065e000)
[...]
[    3.415405] [<c031df90>] (composite_setup+0x738/0xbb4) from [<c0310d18>] (musb_g_ep0_irq+0x9d0/0xaf8)
[    3.425109] [<c0310d18>] (musb_g_ep0_irq+0x9d0/0xaf8) from [<c030fb04>] (musb_interrupt+0xb48/0xc74)
[    3.434722] [<c030fb04>] (musb_interrupt+0xb48/0xc74) from [<c030fc98>] (generic_interrupt+0x68/0x80)
[    3.444458] [<c030fc98>] (generic_interrupt+0x68/0x80) from [<c0095204>] (handle_irq_event_percpu+0x9c/0x234)
[    3.454925] [<c0095204>] (handle_irq_event_percpu+0x9c/0x234) from [<c00953e8>] (handle_irq_event+0x4c/0x6c)
[    3.465270] [<c00953e8>] (handle_irq_event+0x4c/0x6c) from [<c0097e10>] (handle_fasteoi_irq+0xd8/0x110)
[    3.475158] [<c0097e10>] (handle_fasteoi_irq+0xd8/0x110) from [<c0094d2c>] (generic_handle_irq+0x34/0x3c)
[    3.485260] [<c0094d2c>] (generic_handle_irq+0x34/0x3c) from [<c0014ae4>] (handle_IRQ+0x88/0xc8)
[    3.494537] [<c0014ae4>] (handle_IRQ+0x88/0xc8) from [<c00085b0>] (asm_do_IRQ+0x18/0x1c)
[    3.503051] [<c00085b0>] (asm_do_IRQ+0x18/0x1c) from [<c0429e78>] (__irq_svc+0x38/0xc0)

This patch changes Kconfig so that USB_GADGET_DUALSPEED is selected
automatically by USB_MUSB_HDRC.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/usb/musb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index fc34b8b..8da38b6 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -11,6 +11,7 @@ config USB_MUSB_HDRC
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
+	select USB_GADGET_DUALSPEED
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	help
 	  Say Y here if your system has a dual role high speed USB
-- 
1.7.4.1

