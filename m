Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2FNKtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:49:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:56227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2FNKtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156290841"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "Yanmin Zhang <yanmin_zhang@linux.intel.com>
	(yanmin_zhang@linux.intel.com)" <yanmin_zhang@linux.intel.com>
Subject: [PATCH] sdio: Change pr_warning to pr_warn_ratelimited
Thread-Topic: [PATCH] sdio: Change pr_warning to pr_warn_ratelimited
Thread-Index: Ac1KG1XcBL0C2+kjQFSVtqfmWVtm0Q==
Date: Thu, 14 Jun 2012 10:49:17 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A0DD517@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] sdio: Change pr_warning to pr_warn_ratelimited

When debug one bad issue, got lots of pr_warning messages
"queuing unknown CIS tuple" which caused the printk storm
and flooded the console.

This patch is changing the pr_warning api to pr_warn_ratelimited.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/mmc/core/sdio_cis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index f1c7ed8..8e94e55 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -313,7 +313,7 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 
                        if (ret == -ENOENT) {
                                /* warn about unknown tuples */
-                               pr_warning("%s: queuing unknown"
+                               pr_warn_ratelimited("%s: queuing unknown"
                                       " CIS tuple 0x%02x (%u bytes)\n",
                                       mmc_hostname(card->host),
                                       tpl_code, tpl_link);
-- 
1.7.0.4
