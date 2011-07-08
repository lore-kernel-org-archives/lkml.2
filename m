Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1GHIzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:55:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40031 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1GHIzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:55:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/12] gma500: reversed test in mdfld_dbi_dsr_exit()
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:45:32 +0100
Message-ID: <20110708084529.19581.46172.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

We should only cleanup "dsr_info" if it's non-NULL obviously and not
the other way around.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_dsi_dbi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
index 9d2d97d..4897345 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -642,7 +642,7 @@ void mdfld_dbi_dsr_exit(struct drm_device *dev)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
 
-	if (!dsr_info) {
+	if (dsr_info) {
 		del_timer_sync(&dsr_info->dsr_timer);
 		kfree(dsr_info);
 		dev_priv->dbi_dsr_info = NULL;

