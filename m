Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1IMHpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:45:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:63515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab1IMHpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,373,1312182000"; 
   d="scan'208";a="16482116"
Subject: [PATCH -v2] netconsole: switch init_netconsole() to late_initcall
 if build-in
From: Lin Ming <ming.m.lin@intel.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 15:45:39 +0800
Message-ID: <1315899939.3402.2.camel@snb>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88491d8(drivers/net: Kconfig & Makefile cleanup) causes a
regression that netconsole does not work if netconsole and network
device driver are build into kernel, because netconsole is linked
before network device driver.

Andrew Morton suggested to fix this with initcall ordering.
Fixes it by switching init_netconsole() to late_initcall if build-in.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/net/netconsole.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index dfc8272..914be29 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -799,5 +799,9 @@ static void __exit cleanup_netconsole(void)
 	}
 }
 
+#ifdef MODULE
 module_init(init_netconsole);
 module_exit(cleanup_netconsole);
+#else
+late_initcall(init_netconsole);
+#endif /* !MODULE */
-- 
1.7.2.5



