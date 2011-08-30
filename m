Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1H3BNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:54209 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1H3BN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,299,1312182000"; 
   d="scan'208";a="46268999"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Mon, 29 Aug 2011 18:12:11 -0700
Subject: RE: [PATCH 1/3] x86, intel: Output microcode revision v4
Thread-Topic: [PATCH 1/3] x86, intel: Output microcode revision v4
Thread-Index: AcxmpgZll5faXVWQQdyLa7zJ5fBCHgAC66HA
Message-ID: <493994B35A117E4F832F97C4719C4C040133090FB8@orsmsx505.amr.corp.intel.com>
References: <1314661640-10991-1-git-send-email-andi@firstfloor.org>
 <1314661640-10991-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1314661640-10991-3-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>--- a/arch/x86/kernel/cpu/intel.c
>+++ b/arch/x86/kernel/cpu/intel.c
>@@ -364,6 +364,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>
>       early_init_intel(c);
>
>+       if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64)) {
>+               unsigned lower_word;
>+
>+               wrmsr(MSR_IA32_UCODE_REV, 0, 0);
>+               /* The CPUID 1 fills in the MSR as documented in the SDM */
>+               cpuid_eax(1);
>+               rdmsr(MSR_IA32_UCODE_REV, lower_word, c->microcode);
>+       }
>+

The patch initializes c->microcode AFTER it was used in early_init_intel(c) in your patch set [2/3].

Thanks.

-Fenghua
