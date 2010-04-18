Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0DRSVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:21:52 -0400
Received: from tex.lwn.net ([70.33.254.29]:35370 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0DRSVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:36 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 11/11] suppress verbose debug messages:  change printk() to DEBUG_MSG()
Date: Sun, 18 Apr 2010 12:21:13 -0600
Message-Id: <1271614873-5952-12-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

[jc: no signoff, added my own]
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 8f8e0bf..fe5535c 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -26,7 +26,7 @@ static void via_i2c_setscl(void *data, int state)
 	u8 val;
 	struct via_i2c_adap_cfg *adap_data = data;
 
-	printk(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
+	DEBUG_MSG(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
 		adap_data->ioport_index, adap_data->io_port);
 	val = viafb_read_reg(adap_data->io_port,
 			     adap_data->ioport_index) & 0xF0;
@@ -140,7 +140,7 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 			  struct via_i2c_adap_cfg *adap_cfg,
 			  struct pci_dev *pdev)
 {
-	printk(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
+	DEBUG_MSG(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
 
 	algo->setsda = via_i2c_setsda;
 	algo->setscl = via_i2c_setscl;
-- 
1.7.0.1

