Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab1EHW5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:57:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53450 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab1EHWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OTJSJuejydmIYXCaEY4LNVXmnpOoonzqnmWS44ux0ZWlYonOdaSFVCpEGcTuXPLWeo
         EWWyJvMastzFm/ImRSjuNlsEvM9il6Z5APh4khbZ8pGSlQ2Z1gUXmWoba7WHw4I+tvr5
         Of23hm38/PDza+GtJ5//U9NwRgP0gJWBG2imk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 043/115] sysctl: remove .child from kernel/perfmon/ (ia64)
Date: Mon,  9 May 2011 00:38:55 +0200
Message-Id: <1304894407-32201-44-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/ia64/kernel/perfmon.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 89accc6..96743dd 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -552,22 +552,13 @@ static ctl_table pfm_ctl_table[]={
 	},
 	{}
 };
-static ctl_table pfm_sysctl_dir[] = {
-	{
-		.procname	= "perfmon",
-		.mode		= 0555,
-		.child		= pfm_ctl_table,
-	},
- 	{}
-};
-static ctl_table pfm_sysctl_root[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= pfm_sysctl_dir,
-	},
- 	{}
+
+static const __initdata struct ctl_path pfm_path[] = {
+	{ .procname = "kernel" },
+	{ .procname = "perfmon" },
+	{ }
 };
+
 static struct ctl_table_header *pfm_sysctl_header;
 
 static int pfm_context_unload(pfm_context_t *ctx, void *arg, int count, struct pt_regs *regs);
@@ -6687,7 +6678,7 @@ pfm_init(void)
 	/*
 	 * create /proc/sys/kernel/perfmon (for debugging purposes)
 	 */
-	pfm_sysctl_header = register_sysctl_table(pfm_sysctl_root);
+	pfm_sysctl_header = register_sysctl_paths(pfm_path, pfm_ctl_table);
 
 	/*
 	 * initialize all our spinlocks
-- 
1.7.5.134.g1c08b

