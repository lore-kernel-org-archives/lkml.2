Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BUOT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:19:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47533 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2BUOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:19:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.92.227 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
	<alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
	<CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
	<CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
	<4F42FE08.5020309@zytor.com>
	<CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
Date: Tue, 21 Feb 2012 09:19:24 -0500
Message-ID: <CA+5PVA6b-rp84c5Q_foaCWy016mJpM_Na_tdoj5MSL8G4rhoMw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Feb 20, 2012 at 6:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/20/2012 06:10 PM, Linus Torvalds wrote:
>>>
>>> Although I do wonder if we should just make kernel_fpu_begin() be a
>>> real function instead of inlining it. I'm not sure it makes sense to
>>> inline that thing, and it might be better to export that one instead.
>>> Comments?
>>
>> I would agree with that.
>
> So I have a patch that does that, but it's noticeably bigger.
>
> It uninlines a fair amount of i387.h, and moves it into i387.c. I do
> think it's probably the right thing to do, though.
>
> I did a "make allmodconfig" with this on x86-64, but it's quite
> possible that x86-32 does additional cases. Does this patch work for
> people?
>
> (This is *on*top*of* the quick "let's just get it to work" patch that
> just exports the new percpu variable. I already committed that and
> pushed it out, since I wanted a quick fix so that people wouldn't be
> held up by this)
>
> IOW, if you can try this on top of current -git, that would be lovely.

The quick patch cleared up the build issue I was seeing.  Thanks for the quick
fix.  I'll try building with this one a bit later today as well.

josh
