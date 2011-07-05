Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1GEOyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:54:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50615 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1GEOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:54:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 48/49] gma500: Fix missing memory check
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:45:00 +0100
Message-ID: <20110705144457.23872.99994.stgit@localhost.localdomain>
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

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/intel_bios.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/intel_bios.c b/drivers/staging/gma500/intel_bios.c
index 1c4714d..096757f 100644
--- a/drivers/staging/gma500/intel_bios.c
+++ b/drivers/staging/gma500/intel_bios.c
@@ -139,14 +139,18 @@ static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
 	if (!lvds_lfp_data)
 		return;
 
-	dev_priv->lvds_vbt = 1;
 
 	entry = &lvds_lfp_data->data[lvds_options->panel_type];
 	dvo_timing = &entry->dvo_timing;
 
 	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode),
 				      GFP_KERNEL);
+	if (panel_fixed_mode == NULL) {
+		dev_err(dev_priv->dev->dev, "out of memory for fixed panel mode\n");
+		return;
+	}
 
+	dev_priv->lvds_vbt = 1;
 	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
 
 	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {

