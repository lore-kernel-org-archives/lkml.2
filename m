Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab2GGJW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 05:22:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GGJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 05:22:25 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] drm/mgag200: fix null pointer dereference
Date: Sat,  7 Jul 2012 14:52:15 +0530
Message-Id: <1341652935-19188-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are referencing the pointer after doing alloc_apertures,
as alloc_apertures kzallocs, the kzalloc may fail and we get a NULL.

so we need to check for NULL before we dereference this pointer

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/gpu/drm/mgag200/mgag200_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.c b/drivers/gpu/drm/mgag200/mgag200_drv.c
index 93e832d..ea1024d 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.c
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.c
@@ -47,6 +47,9 @@ static void mgag200_kick_out_firmware_fb(struct pci_dev *pdev)
 	bool primary = false;
 
 	ap = alloc_apertures(1);
+	if (!ap)
+		return;
+
 	ap->ranges[0].base = pci_resource_start(pdev, 0);
 	ap->ranges[0].size = pci_resource_len(pdev, 0);
 
-- 
1.7.9.5

