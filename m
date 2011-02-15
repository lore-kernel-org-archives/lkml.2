Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1BOBns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:43:48 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58996 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1BOBnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:43:42 -0500
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 3/4] PCI: introduce reset_resource()
Date: Mon, 14 Feb 2011 17:43:19 -0800
Message-Id: <1297734200-23327-4-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduced reset_resource() which factors out resource reset logic.

    Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index bcf5752..a94ecc1 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -88,6 +88,13 @@ static void __dev_sort_resources(struct pci_dev *dev,
 	pdev_sort_resources(dev, head);
 }
 
+static inline void reset_resource(struct resource *res)
+{
+	res->start = 0;
+	res->end = 0;
+	res->flags = 0;
+}
+
 static void __assign_resources_sorted(struct resource_list *head,
 				 struct resource_list_x *fail_head)
 {
@@ -109,9 +116,7 @@ static void __assign_resources_sorted(struct resource_list *head,
 				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
 					add_to_failed_list(fail_head, list->dev, res);
 			}
-			res->start = 0;
-			res->end = 0;
-			res->flags = 0;
+			reset_resource(res);
 		}
 		tmp = list;
 		list = list->next;
-- 
1.6.5.2

