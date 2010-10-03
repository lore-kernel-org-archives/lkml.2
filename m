Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0JCWXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 18:23:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0JCWXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 18:23:48 -0400
X-User-Agent: K-9 Mail for Android
References: <20101003093701.GB3733@liondog.tnic> <4CA89681.8000202@zytor.com> <20101003152212.GA13233@liondog.tnic> <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com> <20101003201139.GA16532@liondog.tnic>
In-Reply-To: <20101003201139.GA16532@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, cpu: X86_FEATURE_NOPL should be disabled on 32-bit only
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 03 Oct 2010 15:22:13 -0700
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Message-ID: <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort of... only if the input is a constant.

"Borislav Petkov" <bp@alien8.de> wrote:

>From: "H. Peter Anvin" <hpa@zytor.com>
>Date: Sun, Oct 03, 2010 at 11:19:18AM -0700
>
>> I think we actually need to set it on 64 bits.
>
>Ok, correct me if I'm wrong but I think it is already "indirectly" set
>on 64-bits through REQUIRED_MASK3:
>
>#define REQUIRED_MASK3  (NEED_NOPL)
>
>which is defined as
>
>#define NEED_NOPL      (1<<(X86_FEATURE_NOPL & 31))
>
>when either CONFIG_X86_P6_NOP or CONFIG_X86_64 are selected.
>
>and cpu_has() does
>
>#define cpu_has(c, bit)                                                 \
>        (__builtin_constant_p(bit) &&                                   \
>	...
>           (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||     \
>	...
>	? 1 : test_cpu_cap(c, bit))
>
>which returns 1 when testing for X86_FEATURE_NOPL, no?
>
>-- 
>Regards/Gruss,
>    Boris.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
