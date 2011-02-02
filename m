Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1BBAni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:45455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1BBAnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504926"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: andrew.vasquez@qlogic.com, Madhu.Iyengar@qlogic.com,
        James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [29/139] qla2xxx: Correct issue where NPIV-config data was not being allocated for 82xx parts.
Message-Id: <20110202004344.2F2833E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 087c621e22f49c326cdc65d98c6fc0737ac13533 upstream.

This would cause a panic while reading the NPIV-config data.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/qla2xxx/qla_os.c
+++ linux-2.6.35.y/drivers/scsi/qla2xxx/qla_os.c
@@ -2102,6 +2102,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_82XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla82xx_isp_ops;
 		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
