Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1EHWoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:44:22 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47696 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab1EHWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QwpkPSnzq4SuqZxHGc0bdX0hohhYXH7LJkvxPO0UchfadYLVn3dFY13hVgo9tLcsgE
         lOoMnHxlvAaCMwciDzu3YR+EVU9HKXQv4PgGsmELYsjiXgQRRtyMDqMWIQxXAc3G4xY8
         jDDRPVsKu7Do7/9wcInynkrykR0RNlEudZwvA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 093/115] sysctl: ax25: create empty dir with register_sysctl_dir
Date: Mon,  9 May 2011 00:39:45 +0200
Message-Id: <1304894407-32201-94-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ax25/af_ax25.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 965662d..d8a4ea4 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1996,7 +1996,6 @@ static const struct __initdata ctl_path ax25_path[] = {
 	{ .procname = "ax25" },
 	{ }
 };
-static struct ctl_table empty;
 static struct ctl_table_header *ax25_root_header;
 #endif /* CONFIG_SYSCTL */
 
@@ -2014,7 +2013,7 @@ static int __init ax25_init(void)
 
 	/* XXX: no error checking done in initializer */
 	#ifdef CONFIG_SYSCTL
-	ax25_root_header = register_sysctl_paths(ax25_path, &empty);
+	ax25_root_header = register_sysctl_dir(ax25_path);
 	#endif
 
 	proc_net_fops_create(&init_net, "ax25_route", S_IRUGO, &ax25_route_fops);
-- 
1.7.5.134.g1c08b

