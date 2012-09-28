Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118Ab2I1VDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:03:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53208 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032959Ab2I1UrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:08 -0400
X-Sasl-enc: 5ukVrhY+9DKXU5lxhndsdctCSSZh9NP++eVmFPcwBPSG 1348865227
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 064/127] can: janz-ican3: fix support for older hardware revisions
Date: Fri, 28 Sep 2012 13:33:57 -0700
Message-Id: <20120928203053.364060073@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

commit e21093ef6fb4cbecdf926102286dbe280ae965db upstream.

The Revision 1.0 Janz CMOD-IO Carrier Board does not have support for
the reset registers. To support older hardware, the code is changed to
use the hardware reset register on the Janz VMOD-ICAN3 hardware itself.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/janz-ican3.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1249,7 +1249,6 @@ static irqreturn_t ican3_irq(int irq, vo
  */
 static int ican3_reset_module(struct ican3_dev *mod)
 {
-	u8 val = 1 << mod->num;
 	unsigned long start;
 	u8 runold, runnew;
 
@@ -1263,8 +1262,7 @@ static int ican3_reset_module(struct ica
 	runold = ioread8(mod->dpm + TARGET_RUNNING);
 
 	/* reset the module */
-	iowrite8(val, &mod->ctrl->reset_assert);
-	iowrite8(val, &mod->ctrl->reset_deassert);
+	iowrite8(0x00, &mod->dpmctrl->hwreset);
 
 	/* wait until the module has finished resetting and is running */
 	start = jiffies;


