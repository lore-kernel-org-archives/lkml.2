Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1LTPqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:46:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39418 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LTPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:46:06 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] gma500: Oaktrail fixes
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 15:58:29 +0000
Message-ID: <20111220155820.11629.86054.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The move to connectors breaks Oaktrail again if we have memory poisoning
enabled. Fix this.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/oaktrail_lvds.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 965d47c..7dc892a 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -329,8 +329,7 @@ void oaktrail_lvds_init(struct drm_device *dev,
 	struct psb_intel_connector *psb_intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
-	struct drm_psb_private *dev_priv =
-				(struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct edid *edid;
 	int ret = 0;
 	struct i2c_adapter *i2c_adap;
@@ -340,7 +339,7 @@ void oaktrail_lvds_init(struct drm_device *dev,
 	if (!psb_intel_encoder)
 		return;
 
-	psb_intel_connector = kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_connector), GFP_KERNEL);
 	if (!psb_intel_connector)
 		goto failed_connector;
 

