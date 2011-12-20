Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1LTPqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:46:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39420 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LTPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:46:18 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] oaktrail: panel display quality fix
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 15:58:44 +0000
Message-ID: <20111220155841.11629.58178.stgit@bob.linux.org.uk>
In-Reply-To: <20111220155820.11629.86054.stgit@bob.linux.org.uk>
References: <20111220155820.11629.86054.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The GCT setup was used on Moorestown. The Oaktrail version uses a normal PC
interface. That means we must also honour the dither info from the BIOS
data.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/oaktrail_lvds.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 7dc892a..238bbe1 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -375,6 +375,8 @@ void oaktrail_lvds_init(struct drm_device *dev,
 	if (dev_priv->vbt_data.size != 0x00)
 		mode_dev->panel_wants_dither = (dev_priv->gct_data.
 			Panel_Port_Control & MRST_PANEL_8TO6_DITHER_ENABLE);
+        if (dev_priv->lvds_dither)
+                mode_dev->panel_wants_dither = 1;
 
 	/*
 	 * LVDS discovery:

