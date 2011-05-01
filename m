Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab1EABj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab1EABhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rWaqrBREBVEPn0t17tqOBrPiwxn1UYKMi1R15JB3x/wTSXTaDriZjD0Vgze9MHD3Zz
         jtDaW7+6fvsN8ujE0HdMpfwjHxlnd6k/V/IqCUJsdkOC3xlq+Uwt//DbMQN3Jfr58koH
         yok8Jh4Ujt1YsDXyRTWG0c7zBdXAR+ja1YeNw=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 51/69] sysctl: remove .child from net/ipv4/route and net/ipv4/neigh tables
Date: Sun,  1 May 2011 03:36:21 +0200
Message-Id: <1304213799-10257-52-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv4/route.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index c1acf69..6bc621b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3146,18 +3146,10 @@ static ctl_table ipv4_route_table[] = {
 
 static struct ctl_table empty[1];
 
-static struct ctl_table ipv4_skeleton[] =
-{
-	{ .procname = "route", 
-	  .mode = 0555, .child = ipv4_route_table},
-	{ .procname = "neigh", 
-	  .mode = 0555, .child = empty},
-	{ }
-};
-
-static __net_initdata struct ctl_path ipv4_path[] = {
+static __net_initdata struct ctl_path ipv4_neigh_path[] = {
 	{ .procname = "net", },
 	{ .procname = "ipv4", },
+	{ .procname = "neigh", },
 	{ },
 };
 
@@ -3310,6 +3302,7 @@ int __init ip_rt_init(void)
  */
 void __init ip_static_sysctl_init(void)
 {
-	register_sysctl_paths(ipv4_path, ipv4_skeleton);
+	register_sysctl_paths(ipv4_route_path, ipv4_route_table);
+	register_sysctl_paths(ipv4_neigh_path, empty);
 }
 #endif
-- 
1.7.5.134.g1c08b

