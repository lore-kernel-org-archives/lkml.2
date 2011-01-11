Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1AKHl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:41:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1AKHlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:41:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=h6ohDmsBvqLS9lE2xHhVwtGAHnnbSkEL3jlWNTnaFdVgBFnJwmqdNa8brntW6jLLEe
         HRhT3/oqbJWFlROKO2+A==
MIME-Version: 1.0
In-Reply-To: <4D2C05C2.9040705@codeaurora.org>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
	<4D2B71CB.1060004@codeaurora.org>
	<1FC56210173BB445BD77F608D6FB8D03165A00805E@HQMAIL03.nvidia.com>
	<4D2C05C2.9040705@codeaurora.org>
Date: Mon, 10 Jan 2011 23:41:45 -0800
X-Google-Sender-Auth: tXtKkyTtPcYUuWJ1uWzAfK-y6zY
Message-ID: <AANLkTim8Z1VYWVKBRiUFP1tc1uJwpq7Bendqp-F+s+db@mail.gmail.com>
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
From: Colin Cross <ccross@android.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Rakesh Iyer <riyer@nvidia.com>, "jj@chaosbits.net" <jj@chaosbits.net>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:24 PM, Trilok Soni <tsoni@codeaurora.org> wrote:
> Hi Rakesh,
>
> On 1/11/2011 2:41 AM, Rakesh Iyer wrote:
>> Thanks for the review.
>>
>> A quick response regarding the following comment.
>>
>>>
>>>> +
>>>> +#include <linux/module.h>
>>>> +#include <linux/input.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/delay.h>
>>>> +#include <linux/io.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/clk.h>
>>>> +#include <linux/slab.h>
>>>> +#include <mach/clk.h>
>>>
>>> You may not need this.
>>>
>>
>> The mach/clk.h file contains declarations for tegra_periph_reset_assert and tegra_periph_reset_deassert which are needed.
>
> It is really bad if it can't be addressed through clk framework. I will check this, but this
> keyboard controller is on-chip so we should be fine I guess.

The clk framework will deassert reset when a clock is enabled, but it
cannot assert reset when a clock is disabled because some blocks need
to turn of clocks when the block is not in use without reinitializing
the whole block for the next transaction.  If a driver wants to reset
the block, it must call tegra_periph_assert_reset.  Most drivers have
no need to manually reset the block, and do not use these apis at all.

> I hope that these APIs are not required for device drivers which are on external bus like I2C.

These apis set registers internal to Tegra, they have no use for
drivers for external devices.
