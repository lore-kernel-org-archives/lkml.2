Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1EDIV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:21:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:28701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1EDIVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917770626"
Message-Id: <20110504082115.488846050@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 16:17:28 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jaxboe@fusionio.com, htejun@gmail.com, jgarzik@pobox.com,
        hch@infradead.org, djwong@us.ibm.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 3/3] SATA: enable non-queueable flush flag
References: <20110504081725.946950281@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=sata-add-nonqueueable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable non-queueable flush flag for SATA.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/ata/libata-scsi.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/ata/libata-scsi.c
===================================================================
--- linux.orig/drivers/ata/libata-scsi.c	2011-05-04 14:20:41.000000000 +0800
+++ linux/drivers/ata/libata-scsi.c	2011-05-04 14:28:28.000000000 +0800
@@ -3424,7 +3424,9 @@ void ata_scsi_scan_host(struct ata_port
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
+				struct request_queue *q = sdev->request_queue;
 				dev->sdev = sdev;
+				blk_set_queue_flush_queueable(q, false);
 				scsi_device_put(sdev);
 			} else {
 				dev->sdev = NULL;

