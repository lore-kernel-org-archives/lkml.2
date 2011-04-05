Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1DEBzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:55:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1DEBzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=e7BDytRuxKxY559mWhkTYmwNzEeADMVSfuecYS0LtFf0uOhN2dvd2h0s36PxXCiKWR
         qjJi8emi+Dlrh0syqERQ==
MIME-Version: 1.0
In-Reply-To: <4D981EAB.8070209@codeaurora.org>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
	<BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
	<4D981EAB.8070209@codeaurora.org>
Date: Mon, 4 Apr 2011 18:55:31 -0700
X-Google-Sender-Auth: cj1RHyrITE4DGS_vkjFLr3pLaKw
Message-ID: <BANLkTimJkQ9afnO=6gKiBqWUo+Uv=hWx2Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 12:15 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> (Please stop top posting)
>
> On 4/1/2011 3:29 PM, Simon Glass wrote:
>> Hi Stephen,
>>
>> Sorry for the confusion, but in fact I was talking about the patch to
>> make ARM use the generic bug handling via an undef instruction instead
>> of calling ______bug() or writing to memory address 0. Please see
>> here:
>>
>> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6808/1
>
> Yes I've seen your patch (and even posted comments on it which have not
> been responded to).

Hi Stephen,

Not yet! Don't worry I will get to it. I like the suggestion and am
pleased that you pointed me to it, thank you.

> Correct me if I'm wrong, but that patch with CONFIG_BUG=n would lead to
> the same error that Omar is seeing because the code only modifies the
> bug infrastructure when CONFIG_BUG=y.

Well if CONFIG_BUG=n then there is no bug infrastructure, The whole
file is skipped and it falls back to the asm-generic/bug.h which has
even more #ifdefs in it. But I think we end up here:

#define BUG() do {} while(0)

After all the patch removes the *(int*)0 = 0 code by virtue of
CONFIG_GENERIC_BUG=y, right? If I have this wrong then I will have to
break out the C preprocessor...

Regards,
Simon

>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
