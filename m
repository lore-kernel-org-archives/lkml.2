Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2JGX1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:27:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38672 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab2JGXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:25 -0400
Message-Id: <20121007225839.689555720@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 036/108] can: janz-ican3: fix support for older hardware revisions
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

commit e21093ef6fb4cbecdf926102286dbe280ae965db upstream.

The Revision 1.0 Janz CMOD-IO Carrier Board does not have support for
the reset registers. To support older hardware, the code is changed to
use the hardware reset register on the Janz VMOD-ICAN3 hardware itself.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/janz-ican3.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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


