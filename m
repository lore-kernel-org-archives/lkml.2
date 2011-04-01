Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1DAEYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:24:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40057 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1DAEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VFLm4Qh1bqi5Ae9rhaG4Tw1x4LaTpQdjUlt8HSYm5+ZtNxmdg4zpTBQ1Fw2pC/S/qs
         c1Ar5o0/LvC7k7owuMzTQft4wDEFMZVcLz753/XBRw4C3xyUYMo8XyUAdbCmwSv1QlKH
         2t450PROQWGWoVtgUfk1wrUQFOGK9AP0+IrZM=
From: namei.unix@gmail.com
To: shemminger@linux-foundation.org, davem@davemloft.net
Cc: Liu Yuan <tailai.ly@taobao.com>,
        bridge@lists.linux-foundation.org (open list:ETHERNET BRIDGE),
        netdev@vger.kernel.org (open list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/bridge: Fix wrong return-no-vaule
Date: Fri,  1 Apr 2011 12:24:21 +0800
Message-Id: <1301631861-12470-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

In br_stp_if.c/br_stp_recalculate_bridge_id, it should return
false, which indicates that there is no change when we find
that user has chosen a value.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 net/bridge/br_stp_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 5593f5a..9b61d09 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -213,7 +213,7 @@ bool br_stp_recalculate_bridge_id(struct net_bridge *br)
 
 	/* user has chosen a value so keep it */
 	if (br->flags & BR_SET_MAC_ADDR)
-		return;
+		return false;
 
 	list_for_each_entry(p, &br->port_list, list) {
 		if (addr == br_mac_zero ||
-- 
1.7.1

