Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2ILT3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:29:09 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:24751
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab2ILT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:29:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,411,1344204000"; 
   d="scan'208";a="155518698"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ben Dooks <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-s3c24xx/mach-h1940.c: delete double assignment
Date: Wed, 12 Sep 2012 21:28:55 +0200
Message-Id: <1347478135-744-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled, and this may change the behavior of the code.  Without this
change, check_gpio2 could possibly be used uninitialized later.

 arch/arm/mach-s3c24xx/mach-h1940.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index bb8d008..477778c 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -380,7 +380,7 @@ int h1940_led_blink_set(unsigned gpio, int state,
 	default:
 		blink_gpio = S3C2410_GPA(3);
 		check_gpio1 = S3C2410_GPA(1);
-		check_gpio1 = S3C2410_GPA(7);
+		check_gpio2 = S3C2410_GPA(7);
 		break;
 	}
 

