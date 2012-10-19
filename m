Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2JSEQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:16:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58800 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757656Ab2JSEQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:16:33 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 20/21] lockd: Convert ipv4_is_<foo> uses to ipv4_addr_<foo>
Date: Thu, 18 Oct 2012 21:15:04 -0700
Message-Id: <72f0c29d5ad9a3fcc059dbfcef073bea9d9d0de0.1350618012.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350618006.git.joe@perches.com>
References: <cover.1350618006.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new ipv4_addr_<foo> functions to be consistent with
the ipv6_addr_<foo> and eth_addr_<foo> style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/lockd/lockd.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index f5a051a..8fa00e0 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -301,7 +301,7 @@ static inline int __nlm_privileged_request4(const struct sockaddr *sap)
 	if (ntohs(sin->sin_port) > 1023)
 		return 0;
 
-	return ipv4_is_loopback(sin->sin_addr.s_addr);
+	return ipv4_addr_loopback(sin->sin_addr.s_addr);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -313,7 +313,7 @@ static inline int __nlm_privileged_request6(const struct sockaddr *sap)
 		return 0;
 
 	if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_MAPPED)
-		return ipv4_is_loopback(sin6->sin6_addr.s6_addr32[3]);
+		return ipv4_addr_loopback(sin6->sin6_addr.s6_addr32[3]);
 
 	return ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LOOPBACK;
 }
-- 
1.7.8.111.gad25c.dirty

