Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BDMXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1BDMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FeJcKPfyageQK1t163ndaoJ5rJVzlb7gA9/3HzVlalBPuZ3GU5Lto+4Mnt8UUowalS
         l4O26DwEFXbvorRA3Vbk6pBc9JdreDANLyvMn1emtHpjq2Bygg9s6FjHfATngwOWHOV0
         fRRkg50mvVzc91xqPgl3jYpHURAzBA12ETlH4=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/20] mach-omap2: smartreflex: world-writable debugfs voltage files
Date: Fri,  4 Feb 2011 15:23:20 +0300
Message-Id: <96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to change voltage settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile the driver, so it is not tested at all.

 arch/arm/mach-omap2/smartreflex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index c37e823..95ac336 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -900,7 +900,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		return PTR_ERR(dbg_dir);
 	}
 
-	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUGO, dbg_dir,
+	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUSR, dbg_dir,
 				(void *)sr_info, &pm_sr_fops);
 	(void) debugfs_create_x32("errweight", S_IRUGO, dbg_dir,
 			&sr_info->err_weight);
@@ -939,7 +939,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		strcpy(name, "volt_");
 		sprintf(volt_name, "%d", volt_data[i].volt_nominal);
 		strcat(name, volt_name);
-		(void) debugfs_create_x32(name, S_IRUGO | S_IWUGO, nvalue_dir,
+		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
 				&(sr_info->nvalue_table[i].nvalue));
 	}
 
-- 
1.7.0.4

