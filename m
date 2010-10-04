Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0JDWRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:17:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0JDWRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wf1J5dDx3xnN+l0FBUOx9ueU+M5zUjU5vHuiWFsa5WyxXt+yaorgTsvSSpNfa5Pio+
         tiq/X2ux0DmqoIhr9Zxg==
MIME-Version: 1.0
In-Reply-To: <4CAA455D.8000902@zytor.com>
References: <20101003093701.GB3733@liondog.tnic>
	<4CA89681.8000202@zytor.com>
	<20101003152212.GA13233@liondog.tnic>
	<a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
	<20101003201139.GA16532@liondog.tnic>
	<dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
	<20101004073127.GA20305@liondog.tnic>
	<AANLkTikBs5R2KmGfDSXyi5y-cKuZepZCdr0KOVe5-MX6@mail.gmail.com>
	<4CAA4102.3070205@zytor.com>
	<AANLkTimXj+5ixx=xoVYOCmM4+W6CGR1XOi6CHDTZzns0@mail.gmail.com>
	<4CAA455D.8000902@zytor.com>
Date: Mon, 4 Oct 2010 15:17:28 -0700
Message-ID: <AANLkTiniYToWCeVvMXmyUFTudW9g_mpGXRMwQ20kxXUk@mail.gmail.com>
Subject: Re: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
From: Hugh Dickins <hughd@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 2:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/04/2010 02:12 PM, Linus Torvalds wrote:
>> On Mon, Oct 4, 2010 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Actually, cpu_has() depends on:
>>> #if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)
>>
>> Ahh. Right you are. The place that depends on just P6_NOP is the
>> default NOP choice logic in <asm/nops.h>
>>
>> But the end result ends up being the same: can we please clean this
>> all up so that it isn't so confusing? Rather than add to the
>> confusion?
>>
>
> Agreed that this should be cleaned up.  However, in the meantime I'd
> like to keep Borislav's patch in the tree since it makes the code
> technically correct at least.

Another piece of the confusion I noticed a couple of days ago:
X86_MINIMUM_CPU_FAMILY defaults to "6" if X86_32 &&
X86_P6_NOP; whereas X86_P6_NOP depends on X86_64.

Hugh
