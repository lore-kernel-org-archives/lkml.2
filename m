Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1BBAoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1BBAoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418117"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: dhillf@gmail.com, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [62/139] bonding: Fix slave selection bug.
Message-Id: <20110202004418.B020A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <dhillf@gmail.com>

[ Upstream commit af3e5bd5f650163c2e12297f572910a1af1b8236 ]

The returned slave is incorrect, if the net device under check is not
charged yet by the master.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/bonding/bonding.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/bonding/bonding.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/bonding/bonding.h
+++ linux-2.6.35.y/drivers/net/bonding/bonding.h
@@ -235,11 +235,11 @@ static inline struct slave *bond_get_sla
 
 	bond_for_each_slave(bond, slave, i) {
 		if (slave->dev == slave_dev) {
-			break;
+			return slave;
 		}
 	}
 
-	return slave;
+	return 0;
 }
 
 static inline struct bonding *bond_get_bond_by_slave(struct slave *slave)
