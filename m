Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2GPSSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:18:07 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34535 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2GPSSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:18:06 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: vfp: only clear vfp state for current cpu in vfp_pm_suspend
Date: Mon, 16 Jul 2012 11:18:00 -0700
Message-Id: <1342462680-18548-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfp_pm_suspend runs on each cpu, only clear the hardware state
pointer for the current cpu.  Prevents a possible crash if one
cpu clears the hw state pointer when another cpu has already
checked if it is valid.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index ce55f05..fb849d0 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -466,7 +466,7 @@ static int vfp_pm_suspend(void)
 	}
 
 	/* clear any information we had about last context state */
-	memset(vfp_current_hw_state, 0, sizeof(vfp_current_hw_state));
+	vfp_current_hw_state[ti->cpu] = NULL;
 
 	return 0;
 }
-- 
1.7.7.3

