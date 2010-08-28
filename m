Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0H1QFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60829 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0H1QFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xjoou+YmnBmS3irwKJ2Sn2sLRwaaRoltn7pfkikd/0A494Y2WnhKgDQV+6A/96iJYR
         JGBCpFCQwmQNussTw2mbsxHQjz03UdG/n462R7A608vF68+9KxAY+4HweC+0fbwaC/tx
         Fx/8dGpHsZU41So8K9KHtCG1uONVwf44zbjkI=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] x86: Use correct type for %cr4
Date: Sat, 28 Aug 2010 12:04:28 -0400
Message-Id: <1283011478-27237-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%cr4 is 64-bit in 64-bit mode (although the upper 32-bits are currently reserved).
Use unsigned long for the temporary variable to get the right size.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..396b80f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -602,7 +602,7 @@ extern unsigned long		mmu_cr4_features;
 
 static inline void set_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features |= mask;
 	cr4 = read_cr4();
@@ -612,7 +612,7 @@ static inline void set_in_cr4(unsigned long mask)
 
 static inline void clear_in_cr4(unsigned long mask)
 {
-	unsigned cr4;
+	unsigned long cr4;
 
 	mmu_cr4_features &= ~mask;
 	cr4 = read_cr4();
-- 
1.7.2.2

