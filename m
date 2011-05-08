Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1EHWzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:55:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab1EHWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xBBSOMef1nA8N4njCq7nV4ePEw344KPq2zTjquBwex57SYUQ0mPkq2NMuSEU96f15x
         FSRgJpTWnyxd+pGlZ2fZUYo7tsTE7m1gBgVHx4yAQfyScPtFHticdZ5Tq5Qwll5UjAPp
         NhifcgkGhLm5ZYKWj/q3MtBkFmzGHz3Hap/o4=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 052/115] sysctl: remove .child from net/ipv4/neigh table
Date: Mon,  9 May 2011 00:39:04 +0200
Message-Id: <1304894407-32201-53-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv6/sysctl_net_ipv6.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 6dcf5e7..a0d9916 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -17,16 +17,6 @@
 
 static struct ctl_table empty[1];
 
-static ctl_table ipv6_static_skeleton[] = {
-	{
-		.procname	= "neigh",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= empty,
-	},
-	{ }
-};
-
 static ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "route",
@@ -160,11 +150,17 @@ void ipv6_sysctl_unregister(void)
 	unregister_pernet_subsys(&ipv6_sysctl_net_ops);
 }
 
+static const struct ctl_path net_ipv6_neigh_path[] = {
+	{ .procname = "net", },
+	{ .procname = "ipv6", },
+	{ .procname = "neigh", },
+	{ },
+};
 static struct ctl_table_header *ip6_base;
 
 int ipv6_static_sysctl_register(void)
 {
-	ip6_base = register_sysctl_paths(net_ipv6_ctl_path, ipv6_static_skeleton);
+	ip6_base = register_sysctl_paths(net_ipv6_neigh_path, empty);
 	if (ip6_base == NULL)
 		return -ENOMEM;
 	return 0;
-- 
1.7.5.134.g1c08b

