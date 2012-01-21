Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2AUKKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16590 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2AUKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/21] PCI: Move struct resource_list to setup-bus.c
Date: Sat, 21 Jan 2012 02:08:26 -0800
Message-Id: <1327140517-14811-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F1A8EBD.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user outside of setup-bus.c now.

later will convert resource_list to regular list.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    6 ++++++
 include/linux/ioport.h  |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f233d12..b067a4c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -27,6 +27,12 @@
 #include <linux/slab.h>
 #include "pci.h"
 
+struct resource_list {
+	struct resource_list *next;
+	struct resource *res;
+	struct pci_dev *dev;
+};
+
 struct resource_list_x {
 	struct resource_list_x *next;
 	struct resource *res;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 9d57a71..e885ba2 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -23,12 +23,6 @@ struct resource {
 	struct resource *parent, *sibling, *child;
 };
 
-struct resource_list {
-	struct resource_list *next;
-	struct resource *res;
-	struct pci_dev *dev;
-};
-
 /*
  * IO resources have these defined flags.
  */
-- 
1.7.7

