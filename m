Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2F0JB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:01:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20694 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2F0JB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:01:27 -0400
Date: Wed, 27 Jun 2012 12:01:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2 -resend] SCSI: advansys: use a subsystem error code
Message-ID: <20120627090118.GE31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was supposed to be a subsystem specific error code.  It makes
static checkers complain because "warn_code" is unsigned short so it
can't store negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Tue, 20 Sep 2011.

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b2c3a1a..4212586 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4724,7 +4724,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
 	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
-		warn_code = -ENOMEM;
+		warn_code = UW_ERR;
 		goto err_dma_map;
 	}
 	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
