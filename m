Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0EQXtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:49:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41611 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0EQXtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JhpkRbW19TVZXvhpowkCXo8u6q/0v2mb5RLYKDzd1/FAAsszk4yhALKAkR7/5fr1Cp
         2PK6q1YSZ2wkA5Nq9u6ajP9r8U4RSj+yvGe2YfKrhxZzbodNBsd2DZYMb9Yj7TAE8MfO
         vg+mNB9srVZc/bv9laGU6+O0KFOgc9sM7cYGQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86/mmiotrace: remove redundant instruction prefix checks
Date: Tue, 18 May 2010 08:48:30 +0900
Message-Id: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the duplicated entries in prefix_codes[] to eliminate
redundant checks by skip_prefix().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/mm/pf_in.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index df3d5c8..308e325 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -34,7 +34,7 @@
 /* IA32 Manual 3, 2-1 */
 static unsigned char prefix_codes[] = {
 	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
-	0x65, 0x2E, 0x3E, 0x66, 0x67
+	0x65, 0x66, 0x67
 };
 /* IA32 Manual 3, 3-432*/
 static unsigned int reg_rop[] = {
-- 
1.6.0.6

