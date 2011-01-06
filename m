Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1AFA3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:21 -0500
Received: from kroah.org ([198.145.64.141]:35546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1AFA3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:18 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.856176249@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [034/152] [SCSI] qla2xxx: Correct issue where NPIV-config data was not being allocated for 82xx parts.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 087c621e22f49c326cdc65d98c6fc0737ac13533 upstream.

This would cause a panic while reading the NPIV-config data.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2095,6 +2095,7 @@ qla2x00_probe_one(struct pci_dev *pdev,
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_82XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla82xx_isp_ops;
 		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;


