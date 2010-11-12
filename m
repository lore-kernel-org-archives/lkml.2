Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab0KLVjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:39:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab0KLViR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:17 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] drivers/parisc: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:38:00 -0800
Message-Id: <4b2cfc9a82fa77a23a76db463e100b1a7016beee.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parisc/dino.c |   13 +++++--------
 drivers/parisc/hppb.c |    6 ++----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index d9f5148..d30a809 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -599,15 +599,13 @@ dino_fixup_bus(struct pci_bus *bus)
 				
 			}
 					
-			DBG("DEBUG %s assigning %d [0x%lx,0x%lx]\n",
+			DBG("DEBUG %s assigning %d [%pR]\n",
 			    dev_name(&bus->self->dev), i,
-			    bus->self->resource[i].start,
-			    bus->self->resource[i].end);
+			    &bus->self->resource[i]);
 			WARN_ON(pci_assign_resource(bus->self, i));
-			DBG("DEBUG %s after assign %d [0x%lx,0x%lx]\n",
+			DBG("DEBUG %s after assign %d [%pR]\n",
 			    dev_name(&bus->self->dev), i,
-			    bus->self->resource[i].start,
-			    bus->self->resource[i].end);
+			    &bus->self->resource[i]);
 		}
 	}
 
@@ -809,8 +807,7 @@ dino_bridge_init(struct dino_device *dino_dev, const char *name)
 		result = ccio_request_resource(dino_dev->hba.dev, &res[i]);
 		if (result < 0) {
 			printk(KERN_ERR "%s: failed to claim PCI Bus address "
-			       "space %d (0x%lx-0x%lx)!\n", name, i,
-			       (unsigned long)res[i].start, (unsigned long)res[i].end);
+			       "space %d (%pR)!\n", name, i, &res[i]);
 			return result;
 		}
 	}
diff --git a/drivers/parisc/hppb.c b/drivers/parisc/hppb.c
index 815db17..898208e 100644
--- a/drivers/parisc/hppb.c
+++ b/drivers/parisc/hppb.c
@@ -74,10 +74,8 @@ static int hppb_probe(struct parisc_device *dev)
 
 	status = ccio_request_resource(dev, &card->mmio_region);
 	if(status < 0) {
-		printk(KERN_ERR "%s: failed to claim HP-PB "
-			"bus space (0x%08llx, 0x%08llx)\n",
-			__FILE__, (unsigned long long) card->mmio_region.start,
-			(unsigned long long) card->mmio_region.end);
+		printk(KERN_ERR "%s: failed to claim HP-PB bus space (%pR)\n",
+			__FILE__, &card->mmio_region);
 	}
 
         return 0;
-- 
1.7.3.1.g432b3.dirty

