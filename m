Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0F1TGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:06:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:14643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0F1TGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,498,1272870000"; 
   d="scan'208,223";a="634365805"
Message-ID: <4C28F2A1.1030803@linux.intel.com>
Date: Mon, 28 Jun 2010 12:06:09 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <4C2474EF.4050902@cn.fujitsu.com> <4C24CCB7.2020806@zytor.com> <4C285625.6000806@cn.fujitsu.com>
In-Reply-To: <4C285625.6000806@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------040108020000000500070004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040108020000000500070004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/28/2010 12:58 AM, Lai Jiangshan wrote:
> 
> There is alternative in use_xsave().
> use_xsave() should return false in my system, but it returns true after this patch applied.
> 

Does this patch solve your problem?

	-hpa


--------------040108020000000500070004
Content-Type: text/x-patch;
 name="0001-x86-alternatives-correct-obsolete-use-of-u8-in-stati.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-alternatives-correct-obsolete-use-of-u8-in-stati.pa";
 filename*1="tch"

>From be5f348a31cbfa7587903952fa398c8511e23ee9 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Mon, 28 Jun 2010 12:00:18 -0700
Subject: [PATCH] x86, alternatives: correct obsolete use of "u8" in static_cpu_has()

gcc seems to pass unsigned words on as signed to the assembler, at
least with the %P format.  As such, it is critical to get the correct
type.

Furthermore we are no longer limited to features < 256.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4C2474EF.4050902@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 66878c5..e8b8896 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -291,7 +291,7 @@ extern const char * const x86_power_flags[32];
  * patch the target code for additional performance.
  *
  */
-static __always_inline __pure bool __static_cpu_has(u8 bit)
+static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
 		asm goto("1: jmp %l[t_no]\n"
@@ -339,7 +339,7 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
 		boot_cpu_has(bit) :				\
-	(__builtin_constant_p(bit) && !((bit) & ~0xff)) ?	\
+	__builtin_constant_p(bit) ?				\
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
-- 
1.7.0.1


--------------040108020000000500070004--
