Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1COWxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:53:35 -0400
Received: from shutemov.name ([188.40.19.243]:49774 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1COWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:27 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 03/13] dca: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:15 +0200
Message-Id: <1300229605-14499-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>
---
 drivers/dca/dca-core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index c461eda..4abd089 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -111,10 +111,8 @@ static void unregister_dca_providers(void)
 	/* at this point only one domain in the list is expected */
 	domain = list_first_entry(&dca_domains, struct dca_domain, node);
 
-	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
-		list_del(&dca->node);
-		list_add(&dca->node, &unregistered_providers);
-	}
+	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node)
+		list_move(&dca->node, &unregistered_providers);
 
 	dca_free_domain(domain);
 
-- 
1.7.4.1

