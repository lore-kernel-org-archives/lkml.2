Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2BUFfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:35:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40563 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2BUFft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:35:49 -0500
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 21:35:16 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <d52b567f-2fd5-4b9d-b20c-8a83e813caa1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running build tests now; will check results in the morning.

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Mon, Feb 20, 2012 at 6:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/20/2012 06:10 PM, Linus Torvalds wrote:
>>>
>>> Although I do wonder if we should just make kernel_fpu_begin() be a
>>> real function instead of inlining it. I'm not sure it makes sense to
>>> inline that thing, and it might be better to export that one
>instead.
>>> Comments?
>>
>> I would agree with that.
>
>So I have a patch that does that, but it's noticeably bigger.
>
>It uninlines a fair amount of i387.h, and moves it into i387.c. I do
>think it's probably the right thing to do, though.
>
>I did a "make allmodconfig" with this on x86-64, but it's quite
>possible that x86-32 does additional cases. Does this patch work for
>people?
>
>(This is *on*top*of* the quick "let's just get it to work" patch that
>just exports the new percpu variable. I already committed that and
>pushed it out, since I wanted a quick fix so that people wouldn't be
>held up by this)
>
>IOW, if you can try this on top of current -git, that would be lovely.
>
>                         Linus

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
