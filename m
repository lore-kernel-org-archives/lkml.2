Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2BCDvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:51:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37024 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2BCDvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:51:45 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] arm/vfp: vfp_pm_suspend: Use local variable instead of rereading from register
Date: Fri,  3 Feb 2012 09:26:57 +0530
Message-Id: <1328241417-27043-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fpexc variable already stores the value in the FPEXC register.

Use this instead of reading the value again from the register.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f3ccdd..71cd21a 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -448,7 +448,7 @@ static int vfp_pm_suspend(void)
 		vfp_save_state(&ti->vfpstate, fpexc);
 
 		/* disable, just in case */
-		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+		fmxr(FPEXC, fpexc & ~FPEXC_EN);
 	}
 
 	/* clear any information we had about last context state */
-- 
1.7.6

