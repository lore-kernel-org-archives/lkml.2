Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1FAOiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:38:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33685 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab1FAOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hncqPyI3MmBuwnj61zDBS4NzbNEGGkk8Bhy5XXBZFMraT/N0H0AJHLHrMKL5iW0P4Q
         rabzrmVTjTh/WmliY0RCwdU7qu09OjNi44JOI2xHS/DgzWSAMlfVMu8pDbpjujmNSk0B
         55H8VwbUYH/avLFsnt3glPbqYz/LEZbDY0bTo=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Torben Hohn <torbenh@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] xtensa:fix the incompatible pointer type warning in time.c
Date: Wed,  1 Jun 2011 22:37:43 +0800
Message-Id: <1306939063-5489-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the definition of the function ccount_read to be compatible
to the member read of the structure clocksource.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/xtensa/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index f3e5eb4..db18807 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -31,7 +31,7 @@ unsigned long ccount_per_jiffy;		/* per 1/HZ */
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif
 
-static cycle_t ccount_read(void)
+static cycle_t ccount_read(struct clocksource *cs)
 {
 	return (cycle_t)get_ccount();
 }
-- 
1.7.4.1

