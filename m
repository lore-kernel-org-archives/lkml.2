Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1BJV61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:58:27 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28014 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab1BJV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:58:26 -0500
Date: Thu, 10 Feb 2011 22:57:16 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Shmulik Ravid <shmulikr@broadcom.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Lucy Liu <lucy.liu@intel.com>
Subject: [PATCH] Don't potentially dereference NULL in
 net/dcb/dcbnl.c:dcbnl_getapp()
Message-ID: <alpine.LNX.2.00.1102102253230.8012@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nla_nest_start() may return NULL. If it does then we'll blow up in 
nla_nest_end() when we dereference the pointer.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dcbnl.c |    3 +++
 1 file changed, 3 insertions(+)

  only compile tested.

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 6b03f56..13cdc30 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -626,6 +626,9 @@ static int dcbnl_getapp(struct net_device *netdev, struct nlattr **tb,
 	dcb->cmd = DCB_CMD_GAPP;
 
 	app_nest = nla_nest_start(dcbnl_skb, DCB_ATTR_APP);
+	if (!app_nest)
+		goto out_cancel;
+
 	ret = nla_put_u8(dcbnl_skb, DCB_APP_ATTR_IDTYPE, idtype);
 	if (ret)
 		goto out_cancel;
-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

