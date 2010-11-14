Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0KNCHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 21:07:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35525 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0KNCHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 21:07:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=teYqW2dQhmyaeLSxKkkzd9K2hmqgVKI20tc8j6L8Lvj7Di8ZW3RbyxuabK0CD9wLQa
         kACzDJWgck25UDPpD4kIMKJduIBToq0dBjaAL26Bmlm6umClAuuWlPq4AkBNqmdE3Ezf
         uTJzV6e+PbUVqCi0ig5f4Ac9fJOeIV8ivFPs0=
From: Hai Shan <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hai Shan <shan.hai@windriver.com>
Subject: [PATCH] Corrected data type mismatch
Date: Sun, 14 Nov 2010 10:06:59 +0800
Message-Id: <1289700419-11072-2-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289700419-11072-1-git-send-email-shan.hai@windriver.com>
References: <1289700419-11072-1-git-send-email-shan.hai@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected data type mismatch

Signed-off-by: Hai Shan <shan.hai@windriver.com>
---
 arch/powerpc/kernel/kgdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 7a9db64..c5ce65f 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -337,7 +337,7 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 		/* FP registers 32 -> 63 */
 #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
 		if (current)
-			memcpy(mem, current->thread.evr[regno-32],
+			memcpy(mem, (void *)current->thread.evr[regno-32],
 					dbg_reg_def[regno].size);
 #else
 		/* fp registers not used by kernel, leave zero */
@@ -362,7 +362,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
 	if (regno >= 32 && regno < 64) {
 		/* FP registers 32 -> 63 */
 #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
-		memcpy(current->thread.evr[regno-32], mem,
+		memcpy((void *)current->thread.evr[regno-32], mem,
 				dbg_reg_def[regno].size);
 #else
 		/* fp registers not used by kernel, leave zero */
-- 
1.7.0.4

