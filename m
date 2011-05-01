Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1EABiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab1EABhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xCnaHs+w5Td/7eodAvyAWpZFlgdCrBzbsRpcfxxeu9h/4Eo1PD6YwLBleOonRim2+3
         uzfvs48C0AepWdXkKLcOq1Zxik8QZSULgIdGJY/0whf/JONiW+FV/UEBsvNAL+iOaaSU
         UzgMarkdXubOoOPuNf1JayoGENrGlAwHlUuhc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 10/69] sysctl: remove .child from dev/hpet/
Date: Sun,  1 May 2011 03:35:40 +0200
Message-Id: <1304213799-10257-11-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/char/hpet.c |   38 ++++++++++++--------------------------
 1 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 7066e80..303de7e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -721,33 +721,19 @@ static int hpet_is_known(struct hpet_data *hdp)
 
 static ctl_table hpet_table[] = {
 	{
-	 .procname = "max-user-freq",
-	 .data = &hpet_max_freq,
-	 .maxlen = sizeof(int),
-	 .mode = 0644,
-	 .proc_handler = proc_dointvec,
-	 },
-	{}
+		.procname = "max-user-freq",
+		.data     = &hpet_max_freq,
+		.maxlen   = sizeof(int),
+		.mode     = 0644,
+		.proc_handler = proc_dointvec,
+	},
+	{ }
 };
 
-static ctl_table hpet_root[] = {
-	{
-	 .procname = "hpet",
-	 .maxlen = 0,
-	 .mode = 0555,
-	 .child = hpet_table,
-	 },
-	{}
-};
-
-static ctl_table dev_root[] = {
-	{
-	 .procname = "dev",
-	 .maxlen = 0,
-	 .mode = 0555,
-	 .child = hpet_root,
-	 },
-	{}
+static const struct ctl_path hpet_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "hpet" },
+	{ }
 };
 
 static struct ctl_table_header *sysctl_header;
@@ -1053,7 +1039,7 @@ static int __init hpet_init(void)
 	if (result < 0)
 		return -ENODEV;
 
-	sysctl_header = register_sysctl_table(dev_root);
+	sysctl_header = register_sysctl_paths(hpet_path, hpet_table);
 
 	result = acpi_bus_register_driver(&hpet_acpi_driver);
 	if (result < 0) {
-- 
1.7.5.134.g1c08b

