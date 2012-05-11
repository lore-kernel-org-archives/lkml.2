Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2EKKnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:43:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab2EKKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:43:10 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 25/25] Staging: comedi: fix printk issue in ni_660x.c
Date: Fri, 11 May 2012 16:08:13 +0530
Message-Id: <1336732693-7408-26-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_660x.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to pr_<level> and dev_<level>
function wherver possible.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_660x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index eea7047..8568ea8 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -748,8 +748,8 @@ static enum NI_660x_Register ni_gpct_to_660x_register(enum ni_gpct_register reg)
 		ni_660x_register = G3InterruptEnable;
 		break;
 	default:
-		printk(KERN_WARNING "%s: unhandled register 0x%x in switch.\n",
-		       __func__, reg);
+		pr_warn("%s: unhandled register 0x%x in switch.\n",
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -773,8 +773,8 @@ static inline void ni_660x_write_register(struct comedi_device *dev,
 		writel(bits, write_address);
 		break;
 	default:
-		printk(KERN_WARNING "%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
-		       __FILE__, __func__, reg);
+		dev_warn(dev->hw_dev, "%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
+			 __FILE__, __func__, reg);
 		BUG();
 		break;
 	}
@@ -796,8 +796,8 @@ static inline unsigned ni_660x_read_register(struct comedi_device *dev,
 		return readl(read_address);
 		break;
 	default:
-		printk(KERN_WARNING "%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
-		       __FILE__, __func__, reg);
+		dev_warn(dev->hw_dev, "%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
+			 __FILE__, __func__, reg);
 		BUG();
 		break;
 	}
-- 
1.7.0.4

