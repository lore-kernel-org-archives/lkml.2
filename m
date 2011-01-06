Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1AFAuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:50:25 -0500
Received: from kroah.org ([198.145.64.141]:35734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab1AFA34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:56 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.664621558@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sathya Perla <sathyap@serverengines.com>,
        Subbu Seetharaman <subbus@serverengines.com>,
        Sarveshwar Bandi <sarveshwarb@serverengines.com>,
        Ajit Khaparde <ajitk@serverengines.com>, Joe Jin <joe.jin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy bug
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 drivers/net/benet/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/benet/be_cmds.c
+++ b/drivers/net/benet/be_cmds.c
@@ -1179,7 +1179,7 @@ int be_cmd_multicast_set(struct be_adapt
 
 		i = 0;
 		netdev_for_each_mc_addr(ha, netdev)
-			memcpy(req->mac[i].byte, ha->addr, ETH_ALEN);
+			memcpy(req->mac[i++].byte, ha->addr, ETH_ALEN);
 	} else {
 		req->promiscuous = 1;
 	}


