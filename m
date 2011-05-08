Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1EHW4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:56:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab1EHWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ImulEuEi7XpdOsiPw9ApoyLgrJhvB5c+bdTuxX7LJ0pmnuT4Ao/iCrXtFUsI+FJfjA
         PnSJsQmrEU4MNTMuiZUZqP/Dc5Mfs+JvNkWjDeL1fsv1/H6M0Hv0hPXEiUeATFLbwoVV
         3uqrEClInHIHbBVislafz+k44/iMXS2x2JI5A=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 045/115] sysctl: remove .child from kernel/powersave-nap (powerpc)
Date: Mon,  9 May 2011 00:38:57 +0200
Message-Id: <1304894407-32201-46-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/powerpc/kernel/idle.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 39a2baa..88d03c5 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -118,19 +118,16 @@ static ctl_table powersave_nap_ctl_table[]={
 	},
 	{}
 };
-static ctl_table powersave_nap_sysctl_root[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= powersave_nap_ctl_table,
-	},
-	{}
+
+static const __initdata struct ctl_path powersave_nap_path[] = {
+	{ .procname = "kernel" },
+	{ }
 };
 
 static int __init
 register_powersave_nap_sysctl(void)
 {
-	register_sysctl_table(powersave_nap_sysctl_root);
+	register_sysctl_paths(powersave_nap_path, powersave_nap_ctl_table);
 
 	return 0;
 }
-- 
1.7.5.134.g1c08b

