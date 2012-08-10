Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2HJOLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:11:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab2HJOK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:10:59 -0400
Date: Fri, 10 Aug 2012 23:10:57 +0900 (JST)
Message-Id: <20120810.231057.1995590202908302498.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] Declaring packet protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring packet protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/packet/af_packet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ceaca7c..4758940 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2564,6 +2564,9 @@ static struct proto packet_proto = {
 	.name	  = "PACKET",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct packet_sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 /*
-- 
1.7.11.2

