Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2KFIf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:35:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:22882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2KFIfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="243053390"
Subject: [PATCH 7/7] IB/srpt: Fix the usage of wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: nab@linux-iscsi.org, roland@purestorage.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352223194.15558.1601.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
	 <1352222555.15558.1589.camel@cliu38-desktop-build>
	 <1352222894.15558.1595.camel@cliu38-desktop-build>
	 <1352223097.15558.1599.camel@cliu38-desktop-build>
	 <1352223194.15558.1601.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:36:15 +0800
Message-ID: <1352223375.15558.1604.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of wait_for_completion_timeout() is always
>= 0 with unsigned int type.

So the condition "ret < 0" or "ret >= 0" is pointless.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cf23c46..1879b47 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3527,7 +3527,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	spin_unlock_irq(&sdev->spinlock);
 
 	res = wait_for_completion_timeout(&release_done, 60 * HZ);
-	WARN_ON(res <= 0);
+	WARN_ON(res == 0);
 }
 
 /**
-- 
1.7.0.4



