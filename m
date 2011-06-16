Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab1FPQx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:53:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51899 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab1FPQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:53:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 23/29] gma500: Only fiddle with clock gating on PSB
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 16 Jun 2011 17:41:51 +0100
Message-ID: <20110616164143.6039.14685.stgit@localhost.localdomain>
In-Reply-To: <20110616160104.6039.44019.stgit@localhost.localdomain>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
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

