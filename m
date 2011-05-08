Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1EHW5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:57:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab1EHWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wa/XClzuZuyNBMA0fQbQhGDDpdR3wg9i/2iao1Oo+aG9aZn8TF18/h8Mfsy1FcMy+7
         dbJ95x8Xt/h6Jl32TmciRY647HWimIoE6jFN7m+x5sdj90P+q4mldvclfn+r+wV15RT2
         /DsV+Y5Biw8rnui36kbHP9pqlADzJy/v7oifA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 042/115] sysctl: remove .child from vm/ (s390)
Date: Mon,  9 May 2011 00:38:54 +0200
Message-Id: <1304894407-32201-43-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/s390/mm/cmm.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index c66ffd8..0ef5bbf 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -348,13 +348,8 @@ static struct ctl_table cmm_table[] = {
 	{ }
 };
 
-static struct ctl_table cmm_dir_table[] = {
-	{
-		.procname	= "vm",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cmm_table,
-	},
+static const __initdata struct ctl_path cmm_path[] = {
+	{ .procname = "vm" },
 	{ }
 };
 
@@ -434,7 +429,7 @@ static int __init cmm_init(void)
 {
 	int rc = -ENOMEM;
 
-	cmm_sysctl_header = register_sysctl_table(cmm_dir_table);
+	cmm_sysctl_header = register_sysctl_paths(cmm_path, cmm_table);
 	if (!cmm_sysctl_header)
 		goto out_sysctl;
 #ifdef CONFIG_CMM_IUCV
-- 
1.7.5.134.g1c08b

