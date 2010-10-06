Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab0JFQzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:55:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59115 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab0JFQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Hvhw+X/4mkqKVaysyZjRQ4lJ9WFJ+S/XuI1BS0LDpx/Kv9Bb+ofdf8KFo24702yldl
         6cPlcTnikPagM46P2iBbLV5VifkFaMhDutnR+9q00XdYCbP4KdmSxKVMP1aKPQ+ichkm
         I6JL5VKxWhB+oNJu3A0Kuh6AGJiIizcGRIIKk=
Date: Wed, 6 Oct 2010 18:33:54 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, amd: Move CPB flag from "flags" to "power management"
 section in /proc/cpuinfo
Message-ID: <20101006163354.GA31153@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Avoid nameless flag in /proc/cpuinfo, ie.

   power management: ts tm 100mhzsteps hwpstate [9]

and indicate CPB support rather in the power management section
instead of the general feature flags section of /proc/cpuinfo.  The
flag is provided with the same cpuid function like the other power
management flags (CPUID Fn8000_0007_EDX).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/powerflags.c  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 220e2ea..3ef222b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,7 +167,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
-#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_CPB		(7*32+ 2) /* "" AMD Core Performance Boost */
 #define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
index 5abbea2..3215558 100644
--- a/arch/x86/kernel/cpu/powerflags.c
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -16,5 +16,6 @@ const char *const x86_power_flags[32] = {
 	"100mhzsteps",
 	"hwpstate",
 	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
+	"cpb",
+	/* nothing */
 };
-- 
1.6.4.4

