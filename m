Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2IKW6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:58:21 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:51239 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2IKW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:58:18 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-can@vger.kernel.org, sameo@linux.intel.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 2/2] can: janz-ican3: fix support for older hardware revisions
Date: Tue, 11 Sep 2012 15:58:15 -0700
Message-Id: <1347404295-7985-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu>
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Tue, 11 Sep 2012 15:58:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The Revision 1.0 Janz CMOD-IO Carrier Board does not have support for
the reset registers. To support older hardware, the code is changed to
use the hardware reset register on the Janz VMOD-ICAN3 hardware itself.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/net/can/janz-ican3.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 98ee438..7edadee 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1391,7 +1391,6 @@ static irqreturn_t ican3_irq(int irq, void *dev_id)
  */
 static int ican3_reset_module(struct ican3_dev *mod)
 {
-	u8 val = 1 << mod->num;
 	unsigned long start;
 	u8 runold, runnew;
 
@@ -1405,8 +1404,7 @@ static int ican3_reset_module(struct ican3_dev *mod)
 	runold = ioread8(mod->dpm + TARGET_RUNNING);
 
 	/* reset the module */
-	iowrite8(val, &mod->ctrl->reset_assert);
-	iowrite8(val, &mod->ctrl->reset_deassert);
+	iowrite8(0x00, &mod->dpmctrl->hwreset);
 
 	/* wait until the module has finished resetting and is running */
 	start = jiffies;
-- 
1.7.8.6

