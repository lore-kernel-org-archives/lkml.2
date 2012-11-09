Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2KIOUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:38 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46820 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab2KIOUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:36 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 05/10] drivers/mfd/sta2x11-mfd: only add sta2x11_mfd if it hasn't already been added
Date: Fri,  9 Nov 2012 15:19:56 +0100
Message-Id: <1352470801-2418-6-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The pci probe method is called twice now, so we have to call
sta2x11_mfd_add() only once to avoid a -EBUSY error.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 8d38ef2..b981dc4 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -585,7 +585,8 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	sta2x11_mfd_setup(pdev, setup_data);
 
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
-	sta2x11_mfd_add(pdev, GFP_ATOMIC);
+	if (!sta2x11_mfd_find(pdev))
+		sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
 	/* Just 2 bars for all mfd's at present */
 	for (i = 0; i < 2; i++) {
-- 
1.7.10.4

