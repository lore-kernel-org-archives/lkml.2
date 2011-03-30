Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1C3JSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51169 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755632Ab1C3JS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:28 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 05/18] gma500: Add moorestown specific data to the device
 structure
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:59:45 +0100
Message-ID: <20110330085942.5897.40346.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown needs somewhere to stash various pipe config registers and the
firmware and fuse configurations

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.h |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index b7b21ae..b4a8f02 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -644,7 +644,8 @@ struct drm_psb_private {
 
 	struct drm_psb_sizes_arg sizes;
 
-	uint32_t fuse_reg_value;
+	u32 fuse_reg_value;
+	u32 video_device_fuse;
 
 	/* pci revision id for B0:D2:F0 */
 	uint8_t platform_rev_id;
@@ -669,6 +670,7 @@ struct drm_psb_private {
 	unsigned int lvds_use_ssc:1;
 	int lvds_ssc_freq;
 	bool is_lvds_on;
+	bool is_mipi_on;
 
 	unsigned int core_freq;
 	uint32_t iLVDS_enable;
@@ -676,6 +678,20 @@ struct drm_psb_private {
 	/*runtime PM state*/
 	int rpm_enabled;
 
+	/* Moorestown specific */
+	struct mrst_vbt vbt_data;
+	struct mrst_gct_data gct_data;
+
+	/* Moorestown pipe config register value cache */
+	uint32_t pipeconf;
+	uint32_t pipeconf1;
+	uint32_t pipeconf2;
+
+	/* Moorestown plane control register value cache */
+	uint32_t dspcntr;
+	uint32_t dspcntr1;
+	uint32_t dspcntr2;
+
 	/*
 	 *Register state
 	 */

