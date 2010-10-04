Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab0JDVNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:13:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932743Ab0JDVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <4CAA4102.3070205@zytor.com>
References: <20101003093701.GB3733@liondog.tnic> <4CA89681.8000202@zytor.com>
 <20101003152212.GA13233@liondog.tnic> <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
 <20101003201139.GA16532@liondog.tnic> <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
 <20101004073127.GA20305@liondog.tnic> <AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
 <4CAA4102.3070205@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Oct 2010 14:12:16 -0700
Message-ID: <AANLkTimXj+5ixx=xoVYOCmM4+W6CGR1XOi6CHDTZzns0@mail.gmail.com>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Actually, cpu_has() depends on:
> #if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)

Ahh. Right you are. The place that depends on just P6_NOP is the
default NOP choice logic in <asm/nops.h>

But the end result ends up being the same: can we please clean this
all up so that it isn't so confusing? Rather than add to the
confusion?

                         Linus
