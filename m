Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1HKJkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:40:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33840 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab1HKJkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:40:39 -0400
From: Julia Lawall <julia@diku.dk>
To: Paul Moore <paul@paul-moore.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netlabel/netlabel_kapi.c: add missing cleanup code
Date: Thu, 11 Aug 2011 11:40:33 +0200
Message-Id: <1313055633-25327-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the same cleanup code for the failure of kzalloc as for the failure of
kstrdup just below.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netlabel/netlabel_kapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 58107d0..225e12c 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -341,7 +341,7 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 
 	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry == NULL)
-		return -ENOMEM;
+		goto cfg_cipsov4_map_add_failure;
 	if (domain != NULL) {
 		entry->domain = kstrdup(domain, GFP_ATOMIC);
 		if (entry->domain == NULL)

