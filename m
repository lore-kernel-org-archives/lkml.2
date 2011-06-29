Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1F2I31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:29:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61808 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab1F2I3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:29:22 -0400
Message-ID: <4E0AE25D.8040102@imgtec.com>
Date: Wed, 29 Jun 2011 09:29:17 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] mmc: dw_mmc: remove unnecessary error messages
References: <4E0AE1FC.3070201@imgtec.com>
In-Reply-To: <4E0AE1FC.3070201@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2011 08:29:18.0400 (UTC) FILETIME=[A35FCC00:01CC3636]
X-SEF-Processed: 7_3_0_01158__2011_06_29_09_29_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove error messages for timeout and CRC failure, since the error code
already indicates the problem.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index fcff3c0..bf2157a 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -908,12 +908,8 @@ static void dw_mci_tasklet_func(unsigned long priv)
 
 			if (status & DW_MCI_DATA_ERROR_FLAGS) {
 				if (status & SDMMC_INT_DTO) {
-					dev_err(&host->pdev->dev,
-						"data timeout error\n");
 					data->error = -ETIMEDOUT;
 				} else if (status & SDMMC_INT_DCRC) {
-					dev_err(&host->pdev->dev,
-						"data CRC error\n");
 					data->error = -EILSEQ;
 				} else {
 					dev_err(&host->pdev->dev,
-- 
1.7.2.3


