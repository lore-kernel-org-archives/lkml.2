Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1DEPE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:04:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1DEO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chuanxiao Dong <chuanxiao.dong@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 16/34] nand/denali: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:03 +0200
Message-Id: <1302015561-21047-17-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Chuanxiao Dong <chuanxiao.dong@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/mtd/nand/denali.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 8c8d3c8..7a3cf8c 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1721,8 +1721,7 @@ static struct pci_driver denali_pci_driver = {
 
 static int __devinit denali_init(void)
 {
-	printk(KERN_INFO "Spectra MTD driver built on %s @ %s\n",
-			__DATE__, __TIME__);
+	printk(KERN_INFO "Spectra MTD driver\n");
 	return pci_register_driver(&denali_pci_driver);
 }
 
-- 
1.7.4.1

