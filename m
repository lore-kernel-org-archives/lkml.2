Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1JVKTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:19:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61756 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1JVKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:19:12 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: [PATCH 48/49] USB: pxa168: xls: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:57:00 +0800
Message-Id: <1319277421-9203-49-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
Cc: Jayachandran C <jayachandranc@netlogicmicro.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/ehci-pxa168.c |    2 +-
 drivers/usb/host/ohci-xls.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pxa168.c b/drivers/usb/host/ehci-pxa168.c
index ac0c16e..f0b776d 100644
--- a/drivers/usb/host/ehci-pxa168.c
+++ b/drivers/usb/host/ehci-pxa168.c
@@ -304,7 +304,7 @@ static int __devinit ehci_pxa168_drv_probe(struct platform_device *pdev)
 	hcd->has_tt = 1;
 	ehci->sbrn = 0x20;
 
-	err = usb_add_hcd(hcd, irq, IRQF_SHARED | IRQF_DISABLED);
+	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
 		goto err5;
 
diff --git a/drivers/usb/host/ohci-xls.c b/drivers/usb/host/ohci-xls.c
index a3a9c6f..38b6bda 100644
--- a/drivers/usb/host/ohci-xls.c
+++ b/drivers/usb/host/ohci-xls.c
@@ -56,7 +56,7 @@ static int ohci_xls_probe_internal(const struct hc_driver *driver,
 		goto err3;
 	}
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
-- 
1.7.1

