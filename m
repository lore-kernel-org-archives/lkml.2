Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1GEOyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:54:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50609 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1GEOyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:54:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 46/49] gma500: Fix backlight crash
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:44:34 +0100
Message-ID: <20110705144431.23872.67718.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to check the NULL case earlier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/backlight.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/backlight.c b/drivers/staging/gma500/backlight.c
index 4027e70..d3e698b 100644
--- a/drivers/staging/gma500/backlight.c
+++ b/drivers/staging/gma500/backlight.c
@@ -38,9 +38,10 @@ void gma_backlight_exit(struct drm_device *dev)
 {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	dev_priv->backlight_device->props.brightness = 0;
-	backlight_update_status(dev_priv->backlight_device);
-	if (dev_priv->backlight_device)
+	if (dev_priv->backlight_device) {
+		dev_priv->backlight_device->props.brightness = 0;
+		backlight_update_status(dev_priv->backlight_device);
 		backlight_device_unregister(dev_priv->backlight_device);
+	}
 #endif
 }

