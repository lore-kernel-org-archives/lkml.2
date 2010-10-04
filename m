Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0JDVsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:48:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36732 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0JDVsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:48:41 -0400
Date: Mon, 4 Oct 2010 23:48:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
Message-ID: <20101004214838.GA26084@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	lkml <linux-kernel@vger.kernel.org>
References: <4CA89681.8000202@zytor.com>
 <20101003152212.GA13233@liondog.tnic>
 <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
 <20101003201139.GA16532@liondog.tnic>
 <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
 <20101004073127.GA20305@liondog.tnic>
 <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
 <4CAA4102.3070205@zytor.com>
 <AANLkTimXj+5ixx=xoVYOCmM4+W6CGR1XOi6CHDTZzns0@mail.gmail.com>
 <4CAA455D.8000902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CAA455D.8000902@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, Oct 04, 2010 at 02:21:33PM -0700

> On 10/04/2010 02:12 PM, Linus Torvalds wrote:
> > On Mon, Oct 4, 2010 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>
> >> Actually, cpu_has() depends on:
> >> #if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)
> > 
> > Ahh. Right you are. The place that depends on just P6_NOP is the
> > default NOP choice logic in <asm/nops.h>
> > 
> > But the end result ends up being the same: can we please clean this
> > all up so that it isn't so confusing? Rather than add to the
> > confusion?
> > 
> 
> Agreed that this should be cleaned up.  However, in the meantime I'd
> like to keep Borislav's patch in the tree since it makes the code
> technically correct at least.

I think the cleanup should be easy: on 64-bit unconditionally return
p6_nops in find_nop_table() since every 64-bit processor should support
them and on 32-bit never return p6_nops since X86_FEATURE_NOPL is not
set there and fall back to intel_nops on non-AMD. Which means we can get
rid of X86_FEATURE_NOPL altogether. Too radical?

Hmmm...

-- 
Regards/Gruss,
    Boris.
