Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab1EABjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1EABhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SdZJKET30gEOubSAp5WEEBCi5/5n/77uMoIv5rZYEf0wV3cr6GQqKedsZRrvOrdWck
         v0FyZyV6/ef+mrdAtTDR/lM4Aehar2ZqC1gFXuHodRw76w6F3le0VHAb0RWdimw9bJkD
         ++d6GehbSCPyQw+5083KDuoG2s0cH1x9vFR8k=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 32/69] sysctl: remove .child from kernel/ (utsname)
Date: Sun,  1 May 2011 03:36:02 +0200
Message-Id: <1304213799-10257-33-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/utsname_sysctl.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index a2cd77e..7606026 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -57,7 +57,7 @@ static int proc_do_uts_string(ctl_table *table, int write,
 #define proc_do_uts_string NULL
 #endif
 
-static struct ctl_table uts_kern_table[] = {
+static struct ctl_table uts_table[] = {
 	{
 		.procname	= "ostype",
 		.data		= init_uts_ns.name.sysname,
@@ -96,18 +96,14 @@ static struct ctl_table uts_kern_table[] = {
 	{}
 };
 
-static struct ctl_table uts_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= uts_kern_table,
-	},
-	{}
+static const __initdata struct ctl_path uts_path[] = {
+	{ .procname = "kernel" },
+	{ },
 };
 
 static int __init utsname_sysctl_init(void)
 {
-	register_sysctl_table(uts_root_table);
+	register_sysctl_paths(uts_path, uts_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b

