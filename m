Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2HJOG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab2HJOGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:06:23 -0400
Date: Fri, 10 Aug 2012 23:06:21 +0900 (JST)
Message-Id: <20120810.230621.1653174210939174948.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] Declaring icmp protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring icmp protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/ping.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 6232d47..5b4d67d 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -748,6 +748,9 @@ struct proto ping_prot = {
 	.unhash =	ping_v4_unhash,
 	.get_port =	ping_v4_get_port,
 	.obj_size =	sizeof(struct inet_sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 EXPORT_SYMBOL(ping_prot);
 
-- 
1.7.11.2

