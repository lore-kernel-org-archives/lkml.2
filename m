Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1BBBBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:01:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:58186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1BBAoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028424"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: joe.jin@oracle.com, sathyap@serverengines.com, subbus@serverengines.com,
        sarveshwarb@serverengines.com, ajitk@serverengines.com,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [61/139] driver/net/benet: fix be_cmd_multicast_set() memcpy bug
Message-Id: <20110202004417.A52A33E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Jin <joe.jin@oracle.com>

[ Upstream commit 3fd40d0ceac9c234243730f4d7a6ffdb2fd3023a ]

Regarding  benet be_cmd_multicast_set() function, now using
netdev_for_each_mc_addr() helper for mac address copy, but
when copying to req->mac[] did not increase of the index.

Cc: Sathya Perla <sathyap@serverengines.com>
Cc: Subbu Seetharaman <subbus@serverengines.com>
Cc: Sarveshwar Bandi <sarveshwarb@serverengines.com>
Cc: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/benet/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/benet/be_cmds.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/benet/be_cmds.c
+++ linux-2.6.35.y/drivers/net/benet/be_cmds.c
@@ -1176,7 +1176,7 @@ int be_cmd_multicast_set(struct be_adapt
 
 		i = 0;
 		netdev_for_each_mc_addr(ha, netdev)
-			memcpy(req->mac[i].byte, ha->addr, ETH_ALEN);
+			memcpy(req->mac[i++].byte, ha->addr, ETH_ALEN);
 	} else {
 		req->promiscuous = 1;
 	}
