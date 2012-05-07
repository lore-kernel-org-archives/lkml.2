Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2EGF2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:28:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:22578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2EGF2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137681796"
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX] PM, domain, Fix link checking when add subdomain
Date: Mon,  7 May 2012 13:28:01 +0800
Message-Id: <1336368481-15723-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current pm_genpd_add_subdomain() will allow duplicated link between
master and slave domain.  This patch fixed it.

Because when current pm_genpd_add_subdomain() checks whether the link
between the master and slave generic PM domain already exists,
slave_links instead of master_links of master domain is used.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1378,7 +1378,7 @@ int pm_genpd_add_subdomain(struct generi
 		goto out;
 	}
 
-	list_for_each_entry(link, &genpd->slave_links, slave_node) {
+	list_for_each_entry(link, &genpd->master_links, master_node) {
 		if (link->slave == subdomain && link->master == genpd) {
 			ret = -EINVAL;
 			goto out;
