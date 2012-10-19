Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2JSEQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:16:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35172 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753066Ab2JSEQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:16:17 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 18/21] ath6kl: Convert ipv4_is_<foo> uses to ipv4_addr_<foo>
Date: Thu, 18 Oct 2012 21:15:02 -0700
Message-Id: <24a0970cbeb1e5841468535182457d9586ab21a3.1350618012.git.joe@perches.com>
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
 drivers/net/wireless/ath/ath6kl/wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c30ab4b..a5624f5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2547,8 +2547,8 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, u8 if_idx,
 	int ret;
 
 	/* Multicast address are not valid */
-	if (ipv4_is_multicast(ips0) ||
-	    ipv4_is_multicast(ips1))
+	if (ipv4_addr_multicast(ips0) ||
+	    ipv4_addr_multicast(ips1))
 		return -EINVAL;
 
 	skb = ath6kl_wmi_get_new_buf(sizeof(struct wmi_set_ip_cmd));
-- 
1.7.8.111.gad25c.dirty

