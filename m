Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1IVJHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:07:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45514 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1IVJH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:07:27 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 52/55] xen: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:19 +0800
Message-Id: <1316681962-8217-53-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
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
---
 drivers/xen/evtchn.c       |    2 +-
 drivers/xen/platform-pci.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index dbc13e9..95e2507 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -265,7 +265,7 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
 	set_port_user(port, u);
 	set_port_enabled(port, true); /* start enabled */
 
-	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, IRQF_DISABLED,
+	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, 0,
 				       u->name, (void *)(unsigned long)port);
 	if (rc >= 0)
 		rc = 0;
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 319dd0a..482beff 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -84,7 +84,7 @@ static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
 static int xen_allocate_irq(struct pci_dev *pdev)
 {
 	return request_irq(pdev->irq, do_hvm_evtchn_intr,
-			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+			IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
 			"xen-platform-pci", pdev);
 }
 
-- 
1.7.4.1

