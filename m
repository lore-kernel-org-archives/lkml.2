Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1KQOMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:12:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51040 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab1KQOMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <4EC515B40200007800061921@nat28.tlf.novell.com>
References: <4EC4F0FD0200007800061840@nat28.tlf.novell.com>
	<CA+rthh-1WxhWPeKE-Aqa5NCatxVoKu9=KHhLygkT1A6K35CBDA@mail.gmail.com>
	<4EC515B40200007800061921@nat28.tlf.novell.com>
Date: Thu, 17 Nov 2011 15:12:35 +0100
Message-ID: <CA+rthh_Qg91ciZMoctAtzSH-q01XTdkDu37Y7fYOvFOswZQDRQ@mail.gmail.com>
Subject: Re: your patch "crypto: sha1 - SSSE3 based SHA1 implementation for
 x86-64" vs xsave
From: Mathias Krause <minipli@googlemail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 2:09 PM, Jan Beulich <JBeulich@suse.com> wrote:
>> I don't see where X86_CR4_OSXSAVE would get reset after xsave init.
>> Can you give me a pointer to that code?
>
> I didn't say it would get cleared. I said it should be used in favor of
> cpu_has_osxsave.
>
>>> Additionally, under a hypervisor, CPUID.OSXSAVE may be set (due to
>>> the hypervisor having enabled xsave), while the kernel may be running
>>> with xsave disabled (e.g. due to a command line option saying so).
>>
>> When noxsave is given on the kernel command line, X86_FEATURE_XSAVE
>> will be cleared and xsave_init() won't call xstate_enable(), so not
>> setting X86_CR4_OSXSAVE. All fine.
>
> But you're not looking at this bit, you're looking at cpu_has_osxsave,
> which is a CPUID bit (not a CR4 one).

You're right. But that's no problem at all, as the cpu_has_* tests are
only to error out early. They also ensure it is save to execute the
next instruction -- xsetbv(). This instruction actually does the xsave
runtime support check by looking at the extended control register XCR0
and the enabled features in there.
So you're right that the cpu_has_osxsave might be superfluous here but
it doesn't hurt either.

Mathias
