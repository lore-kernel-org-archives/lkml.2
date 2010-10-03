Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0JCSU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:20:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42556 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0JCSU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:20:27 -0400
X-User-Agent: K-9 Mail for Android
References: <20101003093701.GB3733@liondog.tnic> <4CA89681.8000202@zytor.com> <20101003152212.GA13233@liondog.tnic>
In-Reply-To: <20101003152212.GA13233@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, cpu: X86_FEATURE_NOPL should be disabled on 32-bit only
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 03 Oct 2010 11:19:18 -0700
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Message-ID: <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we actually need to set it on 64 bits.

"Borislav Petkov" <bp@alien8.de> wrote:

>ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
>cpuid bit only on 32-bit due to various problems with Virtual PC. This
>somehow got lost during the 32- + 64-bit merge so restore the feature
>bit on 64-bit.
>
>Signed-off-by: Borislav Petkov <bp@alien8.de>
>---
> arch/x86/kernel/cpu/common.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>index caa967d..9a2cfeb 100644
>--- a/arch/x86/kernel/cpu/common.c
>+++ b/arch/x86/kernel/cpu/common.c
>@@ -713,7 +713,9 @@ void __init early_cpu_init(void)
>  */
> static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
> {
>+#ifdef CONFIG_X86_32
> 	clear_cpu_cap(c, X86_FEATURE_NOPL);
>+#endif
> }
> 
> static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>-- 
>1.7.2.3
>
>-- 
>Regards/Gruss,
>    Boris.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
