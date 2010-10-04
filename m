Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0JDUsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:48:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244Ab0JDUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20101004073127.GA20305@liondog.tnic>
References: <20101003093701.GB3733@liondog.tnic> <4CA89681.8000202@zytor.com>
 <20101003152212.GA13233@liondog.tnic> <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
 <20101003201139.GA16532@liondog.tnic> <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
 <20101004073127.GA20305@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Oct 2010 13:47:27 -0700
Message-ID: <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 12:31 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
> cpuid bit only on 32-bit due to various problems with Virtual PC. This
> somehow got lost during the 32- + 64-bit merge so restore the feature
> bit on 64-bit. For that, set it explicitly for non-constant arguments of
> cpu_has(). Update comment for future reference.

I don't think this is right.

The cpu_has() logic depends not on x86-64, but on X86_P6_NOP.

Which has

        depends on X86_64
        depends on (MCORE2 || MPENTIUM4 || MPSC)

as its config rules, not just X86_64.

So I think your patch is bogus. It makes the current situation even
_more_ confusing than it is.

So what is it? Should we get rid of that odd X86_P6_NOP thing
entirely? Or should we use it consistently for the "this machine has
NOPL"? Should we always use P6_NOP for x86-64 and just remove the
"MCORE2 || MPENTIUM4 || MPSC" thing?

Whatever we do, I don't think this patch is the right one.

                   Linus
