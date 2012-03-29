Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab2C2Qqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602Ab2C2Qpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:45:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/13] e752x_edac: provide more info about how DIMMS/ranks are mapped
Date: Thu, 29 Mar 2012 13:45:44 -0300
Message-Id: <1333039546-5590-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No funtional changes here. Only the comments got updated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/e752x_edac.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 9f8b763..d862fb4 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -4,10 +4,11 @@
  * This file may be distributed under the terms of the
  * GNU General Public License.
  *
- * See "enum e752x_chips" below for supported chipsets
+ * Implement support for the e7520, E7525, e7320 and i3100 memory controllers.
  *
- * Datasheet:
+ * Datasheets:
  *	http://www.intel.in/content/www/in/en/chipsets/e7525-memory-controller-hub-datasheet.html
+ *	ftp://download.intel.com/design/intarch/datashts/31345803.pdf
  *
  * Written by Tom Zimmerman
  *
@@ -16,8 +17,6 @@
  * 	Wang Zhenyu at intel.com
  * 	Dave Jiang at mvista.com
  *
- * $Id: edac_e752x.c,v 1.5.2.11 2005/10/05 00:43:44 dsp_llnl Exp $
- *
  */
 
 #include <linux/module.h>
@@ -190,6 +189,25 @@ enum e752x_chips {
 	I3100 = 3
 };
 
+/*
+ * Those chips Support single-rank and dual-rank memories only.
+ *
+ * On e752x chips, the odd rows are present only on dual-rank memories.
+ * Dividing the rank by two will provide the dimm#
+ *
+ * i3100 MC has a different mapping: it supports only 4 ranks.
+ *
+ * The mapping is (from 1 to n):
+ *	slot	   single-ranked	double-ranked
+ *	dimm #1 -> rank #4		NA
+ *	dimm #2 -> rank #3		NA
+ *	dimm #3 -> rank #2		Ranks 2 and 3
+ *	dimm #4 -> rank $1		Ranks 1 and 4
+ *
+ * FIXME: The current mapping for i3100 considers that it supports up to 8
+ *	  ranks/chanel, but datasheet says that the MC supports only 4 ranks.
+ */
+
 struct e752x_pvt {
 	struct pci_dev *bridge_ck;
 	struct pci_dev *dev_d0f0;
-- 
1.7.8

