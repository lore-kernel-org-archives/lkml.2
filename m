Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1G0Af0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1G0AfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380445"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: ostr@amd64.org, jvpeetz@web.de, borislav.petkov@amd.com,
        Boris.Ostrovsky@amd.com, ak@linux.intel.com, mingo@elte.hu,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [25/98] x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
Message-Id: <20110727003517.6946C2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Boris Ostrovsky <ostr@amd64.org>

commit e20a2d205c05cef6b5783df339a7d54adeb50962 upstream.

Older AMD K8 processors (Revisions A-E) are affected by erratum
400 (APIC timer interrupts don't occur in C states greater than
C1). This, for example, means that X86_FEATURE_ARAT flag should
not be set for these parts.

This addresses regression introduced by commit
b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT
feature on AMD processors") where the system may become
unresponsive until external interrupt (such as keyboard input)
occurs. This results, for example, in time not being reported
correctly, lack of progress on the system and other lockups.

Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1304113663-6586-1-git-send-email-ostr@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -651,7 +651,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 
 
