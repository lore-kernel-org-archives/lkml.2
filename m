Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab1DNSQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:16:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:41846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab1DNR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Joe Jin <joe.jin@oracle.com>,
        Sathya Perla <sathyap@serverengines.com>,
        Subbu Seetharaman <subbus@serverengines.com>,
        Sarveshwar Bandi <sarveshwarb@serverengines.com>,
        Ajit Khaparde <ajitk@serverengines.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 145/209] driver/net/benet: fix be_cmd_multicast_set() memcpy bug
Date: Thu, 14 Apr 2011 13:55:03 -0400
Message-Id: <1302803767-9715-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 408cc293c29ada769ae772420a39961320da1854 upstream

Regarding  benet be_cmd_multicast_set() function, now using
netdev_for_each_mc_addr() helper for mac address copy, but
when copying to req->mac[] did not increase of the index.

Cc: Sathya Perla <sathyap@serverengines.com>
Cc: Subbu Seetharaman <subbus@serverengines.com>
Cc: Sarveshwar Bandi <sarveshwarb@serverengines.com>
Cc: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/benet/be_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/benet/be_cmds.c b/drivers/net/benet/be_cmds.c
index d0ef4ac..e0578d1 100644
--- a/drivers/net/benet/be_cmds.c
+++ b/drivers/net/benet/be_cmds.c
@@ -1163,7 +1163,7 @@ int be_cmd_multicast_set(struct be_adapter *adapter, u32 if_id,
 
 		i = 0;
 		netdev_for_each_mc_addr(mc, netdev)
-			memcpy(req->mac[i].byte, mc->dmi_addr, ETH_ALEN);
+			memcpy(req->mac[i++].byte, mc->dmi_addr, ETH_ALEN);
 	} else {
 		req->promiscuous = 1;
 	}
-- 
1.7.4.4

