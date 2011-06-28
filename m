Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1F1WIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:08:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41006 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1F1WIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:08:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 22/29] gma500: Only fiddle with clock gating on PSB
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:08:18 +0100
Message-ID: <20110628220816.898.56258.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
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

 drivers/staging/gma500/psb_powermgmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index f837ab0..2253ecb 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -64,7 +64,7 @@ void gma_power_init(struct drm_device *dev)
 	dev_priv->suspended = false;	/* And not suspended */
 	mutex_init(&power_mutex);
 
-	if (!IS_MRST(dev)) {
+	if (!IS_MRST(dev) && !IS_MFLD(dev)) {
 		/* FIXME: wants further review */
 		u32 gating = PSB_RSGX32(PSB_CR_CLKGATECTL);
 		/* Disable 2D clock gating */

