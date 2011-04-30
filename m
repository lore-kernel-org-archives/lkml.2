Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1D3OBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:01:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50574 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752464Ab1D3OBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:45 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18HVpkcEgwHHuo65zB/kRnral061M6xhpVNtCavXb
	UvcksxQ0wu33/z
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: use write combining for video ram
Date: Sat, 30 Apr 2011 14:18:04 +0000
Message-Id: <1304173086-3434-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can give a speed up of factor 6-9, which is quite notable.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/via-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 6723d69..5b0129b 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -505,7 +505,7 @@ static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
 	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
 	if (ret < 0)
 		goto out_unmap;
-	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
+	vdev->fbmem = ioremap_wc(vdev->fbmem_start, vdev->fbmem_len);
 	if (vdev->fbmem == NULL) {
 		ret = -ENOMEM;
 		goto out_unmap;
-- 
1.6.3.2

