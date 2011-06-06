Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1FFAoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:44:20 -0400
Received: from mta11.charter.net ([216.33.127.80]:57909 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1FFAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:44:17 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=be8ZlSnZ4WMA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=Npi6bBMuPX851LGtqNAA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: ron.mercer@qlogic.com
Cc: linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] qlge: remove unecessary if statement
Date: Sun,  5 Jun 2011 19:44:13 -0500
Message-Id: <1307321053-21695-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code always returns 'status' regardless, so if(status) check is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/qlge/qlge_ethtool.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/qlge/qlge_ethtool.c b/drivers/net/qlge/qlge_ethtool.c
index 19b00fa..9b67bfe 100644
--- a/drivers/net/qlge/qlge_ethtool.c
+++ b/drivers/net/qlge/qlge_ethtool.c
@@ -650,8 +650,6 @@ static int ql_set_pauseparam(struct net_device *netdev,
 		return -EINVAL;
 
 	status = ql_mb_set_port_cfg(qdev);
-	if (status)
-		return status;
 	return status;
 }
 
-- 
1.7.2.5

