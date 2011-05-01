Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab1EABjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab1EABht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BLcnBD3EL9JedQWiMw44ztU67qo6LPbMEmF4SasKSoviC0S0jrHuNsOi8/jQkIDk+f
         3VdoXiMSSfxNCW4vwnbgMJqcxuzs+nm3hdu3oNecEXAmMOzI0raKPNtf40j5tFhmDi6K
         NunkGANWRkYEKNr+LlywmVfQZ1fzcWuajVugw=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 45/69] sysctl: remove .child from kernel/powersave-nap (powerpc)
Date: Sun,  1 May 2011 03:36:15 +0200
Message-Id: <1304213799-10257-46-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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

