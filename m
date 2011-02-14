Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1BNCrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:47:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49095 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1BNCrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XpnhKtX/IbJd2Gm1wYkikKcxAopAtq+6Q1iQTTVnQ4Od+YfASdDPwhugSJwBRZmhic
         u1d77p8QaEDcLB+WfG5gM6nFpoNlPGf55OD5pSIqiSGvZuRKHJSNLIi7UEL5TZh49bUn
         7n8M8GOO1WrOQjj6gqmM57LAxp0TgtjXZ7k3I=
Subject: [PATCH] ARM: SAMSUNG: Drop exporting s3c24xx_ts_set_platdata
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Mon, 14 Feb 2011 10:49:27 +0800
Message-Id: <1297651767.13143.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c24xx_ts_set_platdata is annotated __init and not used by any module,
thus don't export it.
This patch fixes below warning:

WARNING: arch/arm/plat-samsung/built-in.o(__ksymtab+0x90): Section mismatch in reference from the variable __ksymtab_s3c24xx_ts_set_platdata to the function .init.text:s3c24xx_ts_set_platdata()
The symbol s3c24xx_ts_set_platdata is exported and annotated __init
Fix this by removing the __init annotation of s3c24xx_ts_set_platdata or drop the export.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/plat-samsung/dev-ts.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/dev-ts.c b/arch/arm/plat-samsung/dev-ts.c
index 236ef84..3e4bd81 100644
--- a/arch/arm/plat-samsung/dev-ts.c
+++ b/arch/arm/plat-samsung/dev-ts.c
@@ -58,4 +58,3 @@ void __init s3c24xx_ts_set_platdata(struct s3c2410_ts_mach_info *pd)
 
 	s3c_device_ts.dev.platform_data = npd;
 }
-EXPORT_SYMBOL(s3c24xx_ts_set_platdata);
-- 
1.7.2



