Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2FKA7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:40 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40540 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2FKA6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:30 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 03/14] sta2x11-mfd : only add sta2x11_mfd if it hasn't already been added
Date: Mon, 11 Jun 2012 02:57:48 +0200
Message-Id: <1339376279-16753-4-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
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
index 69c7bdc..e004c59 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -497,7 +497,8 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	sta2x11_mfd_setup(pdev, setup_data);
 
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
-	sta2x11_mfd_add(pdev, GFP_ATOMIC);
+	if (!sta2x11_mfd_find(pdev))
+		sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
 	/* Just 2 bars for all mfd's at present */
 	for (i = 0; i < 2; i++) {
-- 
1.7.9.1

