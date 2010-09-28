Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0I1NJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:09:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:33444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0I1NJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="329586895"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] apds9802als: fix als sensing range value
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 28 Sep 2010 13:21:28 +0100
Message-ID: <20100928122127.492.81083.stgit@localhost.localdomain>
In-Reply-To: <20100928122109.492.4630.stgit@localhost.localdomain>
References: <20100928122109.492.4630.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Liu <hong.liu@intel.com>

The 4K and 64K in the hw spec acutally means 4095 (12bit) and 65535 (16bit).

Signed-off-by: Hong Liu <hong.liu@intel.com>
---

 drivers/misc/apds9802als.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index cfd004a..a55a215 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -55,9 +55,9 @@ static ssize_t als_sensing_range_show(struct device *dev,
 	if (val < 0)
 		return val;
 	if (val & 1)
-		return sprintf(buf, "4000\n");
+		return sprintf(buf, "4095\n");
 	else
-		return sprintf(buf, "64000\n");
+		return sprintf(buf, "65535\n");
 }
 
 static ssize_t als_lux_output_data_show(struct device *dev,
@@ -111,7 +111,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	/* Reset the bits before setting them */
 	ret_val = ret_val & 0xFA;
 
-	if (val == 1) /* Setting the continous measurement up to 8k LUX */
+	if (val == 1) /* Setting the continous measurement up to 4k LUX */
 		ret_val = (ret_val | 0x05);
 	else /* Setting the continous measurement up to 64k LUX*/
 		ret_val = (ret_val | 0x04);

