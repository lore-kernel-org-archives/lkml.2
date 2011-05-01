Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1EABhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:37:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1EABhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xi1moR672lhffKpDyS8FOPK2/pzzSMaK8ZLcKpXxuv1Kb9E0YlBDRKtXcDm0Yh6fHP
         OJ1Bee6dTsxeMiaDN7CAggMS30maebgThVFSjDvCo54EUUOfcxMbp+4D4UNFjIBzpS6W
         jNlspXSrPpfZdbAfoQKGWk4CjBSNNxkXPWrbE=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 08/69] sysctl: remove .child from crypto/fips_enabled
Date: Sun,  1 May 2011 03:35:38 +0200
Message-Id: <1304213799-10257-9-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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

