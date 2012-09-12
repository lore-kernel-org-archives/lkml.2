Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2ILKX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:23:28 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49722 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab2ILKXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:23:23 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 4/8] sta2x11-mfd : only add sta2x11_mfd if it hasn't already been added
Date: Wed, 12 Sep 2012 12:22:50 +0200
Message-Id: <1347445374-32140-5-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The pci probe method is called twice now, so we have to call
sta2x11_mfd_add() only once to avoid a -EBUSY error.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index a9eeba1..82fe356 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -561,7 +561,8 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	sta2x11_mfd_setup(pdev, setup_data);
 
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
-	sta2x11_mfd_add(pdev, GFP_ATOMIC);
+	if (!sta2x11_mfd_find(pdev))
+		sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
 	/* Just 2 bars for all mfd's at present */
 	for (i = 0; i < 2; i++) {
-- 
1.7.9.1

