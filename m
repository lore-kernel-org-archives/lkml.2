Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2DSQ4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:56:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41081 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016Ab2DSQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:56:00 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Maik Broemme <mbroemme@plusserver.de>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/intelfb/intelfbdrv.c: add missing agp_backend_release
Date: Thu, 19 Apr 2012 18:55:53 +0200
Message-Id: <1334854553-30067-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Release bridge, as done on all other paths out of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/intelfb/intelfbdrv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 02fd226..bdcbfba 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -680,6 +680,7 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
 		 + dinfo->fb.size);
 	if (!dinfo->aperture.virtual) {
 		ERR_MSG("Cannot remap FB region.\n");
+		agp_backend_release(bridge);
 		cleanup(dinfo);
 		return -ENODEV;
 	}
@@ -689,6 +690,7 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
 					      INTEL_REG_SIZE);
 	if (!dinfo->mmio_base) {
 		ERR_MSG("Cannot remap MMIO region.\n");
+		agp_backend_release(bridge);
 		cleanup(dinfo);
 		return -ENODEV;
 	}

