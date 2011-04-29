Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab1D2VuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:50:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1D2VuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:50:13 -0400
From: Boris Ostrovsky <ostr@amd64.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, jvpeetz@web.de, borislav.petkov@amd.com,
        boris.ostrovsky@amd.com, stable@kernel.org
Subject: [PATCH] x86, AMD: K8 Rev.A-E processors are subject to erratum 400
Date: Fri, 29 Apr 2011 17:47:43 -0400
Message-Id: <1304113663-6586-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older AMD K8 processors (Revisions A-E) are affected by erratum 400
(APIC timer interrupts don't occur in C states greater than C1). This,
for example, means that X86_FEATURE_ARAT flag should not be set for
these parts.

This addresses regression introduced by commit
b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT feature
on AMD processors") where the system may become unresponsive until
external interrupt (such as keyboard input) occurs. This results, for
example, in time not being reported correctly, lack of progress on the
system and other lockups.

Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
Cc: stable@kernel.org

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3532d3b..71499b4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,7 +698,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 EXPORT_SYMBOL_GPL(amd_erratum_400);
 
-- 
1.7.3.4

