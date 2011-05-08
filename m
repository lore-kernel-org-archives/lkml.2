Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1EHXFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:05:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1EHWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b0izv/LLZhTIeSiBzgitTu25wPvVgI8atqh6MJ1n7lT1/rWwh8meePrBQk3vTJHcuJ
         kxB1VuGsMmKP3B84gXPpfztADnYCuZacxBbUKhxBx93qy+ouZ5hAw563usykPG5K4Eky
         NT3TbQvkvvgMaEMnQ9ah2THpNgEuUnxeIi9KM=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 008/115] sysctl: remove .child from crypto/fips_enabled
Date: Mon,  9 May 2011 00:38:20 +0200
Message-Id: <1304894407-32201-9-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 crypto/proc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 58fef67..2ef248b 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -34,20 +34,16 @@ static struct ctl_table crypto_sysctl_table[] = {
 	{}
 };
 
-static struct ctl_table crypto_dir_table[] = {
-	{
-		.procname       = "crypto",
-		.mode           = 0555,
-		.child          = crypto_sysctl_table
-	},
-	{}
+static const struct ctl_path crypto_root_path[] = {
+	{ .procname = "crypto" },
+	{ }
 };
 
 static struct ctl_table_header *crypto_sysctls;
 
 static void crypto_proc_fips_init(void)
 {
-	crypto_sysctls = register_sysctl_table(crypto_dir_table);
+	crypto_sysctls = register_sysctl_paths(crypto_root_path, crypto_sysctl_table);
 }
 
 static void crypto_proc_fips_exit(void)
-- 
1.7.5.134.g1c08b

