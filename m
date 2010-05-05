Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0EEWfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:35:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:50628 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab0EEWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:35:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: [PATCH 2/5] viafb: get rid of i2c debug cruft
Date: Wed,  5 May 2010 16:34:41 -0600
Message-Id: <1273098884-21848-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273098884-21848-1-git-send-email-corbet@lwn.net>
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's ugly and adds a global.h dependency.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index febc1dd..84ec2d6 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -52,7 +52,7 @@ static void via_i2c_setscl(void *data, int state)
 		val |= 0x80;
 		break;
 	default:
-		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
+		printk(KERN_ERR "viafb_i2c: specify wrong i2c type.\n");
 	}
 	via_write_reg(adap_data->io_port, adap_data->ioport_index, val);
 	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
@@ -104,7 +104,7 @@ static void via_i2c_setsda(void *data, int state)
 		val |= 0x40;
 		break;
 	default:
-		DEBUG_MSG("viafb_i2c: specify wrong i2c type.\n");
+		printk(KERN_ERR "viafb_i2c: specify wrong i2c type.\n");
 	}
 	via_write_reg(adap_data->io_port, adap_data->ioport_index, val);
 	spin_unlock_irqrestore(&i2c_vdev->reg_lock, flags);
@@ -175,8 +175,6 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 			  struct via_port_cfg *adap_cfg,
 			  struct pci_dev *pdev)
 {
-	DEBUG_MSG(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
-
 	algo->setsda = via_i2c_setsda;
 	algo->setscl = via_i2c_setscl;
 	algo->getsda = via_i2c_getsda;
-- 
1.7.0.1

