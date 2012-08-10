Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2HJOMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611Ab2HJOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:12:36 -0400
Date: Fri, 10 Aug 2012 23:12:34 +0900 (JST)
Message-Id: <20120810.231234.519056740912818977.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] Declaring ax25 protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring ax25 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ax25/af_ax25.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 779095d..a62dd6c 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -803,6 +803,9 @@ static struct proto ax25_proto = {
 	.name	  = "AX25",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 static int ax25_create(struct net *net, struct socket *sock, int protocol,
-- 
1.7.11.2

