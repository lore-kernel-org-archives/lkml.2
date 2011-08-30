Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1H3BKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:10:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:53289 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1H3BKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,299,1312182000"; 
   d="scan'208";a="12302097"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        "jbeulich@novell.com" <jbeulich@novell.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Mon, 29 Aug 2011 18:08:46 -0700
Subject: RE: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Thread-Topic: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Thread-Index: AcxmpgZll5faXVWQQdyLa7zJ5fBCHgACyVBw
Message-ID: <493994B35A117E4F832F97C4719C4C040133090FB4@orsmsx505.amr.corp.intel.com>
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
>@@ -55,17 +55,10 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>        * need the microcode to have already been loaded... so if it is
>        * not, recommend a BIOS update and disable large pages.
 >      */
>-       if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
>-               u32 ucode, junk;
>-
>-               wrmsr(MSR_IA32_UCODE_REV, 0, 0);
>-               sync_core();
>-               rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
>-
>-               if (ucode < 0x20e) {
>-                       printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
>-                       clear_cpu_cap(c, X86_FEATURE_PSE);
>-               }
>+       if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2 &&
>+           c->microcode < 0x20e) {
>+               printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
>+               clear_cpu_cap(c, X86_FEATURE_PSE); 
>       }

c->microcode is used here BEFORE it's initialized in init_intel() in your patch set [1/3].

Thanks.

-Fenghua
