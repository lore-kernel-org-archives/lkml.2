Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0JDVyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43583 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab0JDVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:54:04 -0400
Message-ID: <4CAA4CCB.5090205@zytor.com>
Date: Mon, 04 Oct 2010 14:53:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
References: <4CA89681.8000202@zytor.com> <20101003152212.GA13233@liondog.tnic> <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com> <20101003201139.GA16532@liondog.tnic> <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com> <20101004073127.GA20305@liondog.tnic> <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com> <4CAA4102.3070205@zytor.com> <AANLkTimXj+5ixx=xoVYOCmM4+W6CGR1XOi6CHDTZzns0@mail.gmail.com> <4CAA455D.8000902@zytor.com> <20101004214838.GA26084@liondog.tnic>
In-Reply-To: <20101004214838.GA26084@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 02:48 PM, Borislav Petkov wrote:
> 
> I think the cleanup should be easy: on 64-bit unconditionally return
> p6_nops in find_nop_table() since every 64-bit processor should support
> them and on 32-bit never return p6_nops since X86_FEATURE_NOPL is not
> set there and fall back to intel_nops on non-AMD. Which means we can get
> rid of X86_FEATURE_NOPL altogether. Too radical?
> 

FWIW, if P6_NOPs work as well as 66...90 on AMD, I'd much rather switch
to the fixed sequence for all 64-bit processors.

	-hpa
