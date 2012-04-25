Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2DYQbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:31:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64609 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2DYQbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F981BDE.4050906@stericsson.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
	<20120423101804.GA8318@opensource.wolfsonmicro.com>
	<4F953455.3080002@stericsson.com>
	<20120423110522.GB8318@opensource.wolfsonmicro.com>
	<4F95495D.4050508@stericsson.com>
	<4F954ED6.2040201@stericsson.com>
	<20120423180140.GR8318@opensource.wolfsonmicro.com>
	<CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
	<4F981BDE.4050906@stericsson.com>
Date: Wed, 25 Apr 2012 22:01:49 +0530
Message-ID: <CAJe_ZhfVdHmEizL9X+VZzLq216uk2UzTq2sV3KnOxFwFrjQFTg@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during init
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2012 21:14, Ulf Hansson <ulf.hansson@stericsson.com> wrote:
> On 04/25/2012 05:34 PM, Jassi Brar wrote:
>>>
>>  Shouldn't the bootloader be responsible for ensuring MMC is
>> put down after using it and before passing control to the kernel.
>
> This is kind of complicated. eMMC is powered by two regulators. VCC and
> VCCQ. Cutting VCC uncontrolled is not allowed. If doing so anyway there is
> two options to recover.
>
> 1. Cut VCCQ as well and do full reinit of the eMMC
> 2. Pull a hw-reset pin to the eMMC and do a full reinit of the eMMC.
>
> In some cases neither is possible due to HW constraints. Thus we have to
> make sure VCC is not cut.
>
I meant power-down to whatever extent your h/w permits. The rest you'll
have to take care by appropriately flagging supplies in the kernel.

If not full power-off, couldn't your bootloader atleast send eMMC the necessary
"power-down sequence of commands", so that it responds well to next
power-up sequence of commands ?

The point being, the board files, in both your bootloader and kernel, ought to
know the h/w constraints and program the regulator api accordingly.

Generalizing the case, IMHO it's not feasible for every stack in the kernel to
assume it has to first cleanly shutdown the h/w before probing it.

>>  Even if the bootloader didn't power off properly, unless there is
>> some outstanding data to be written when the kernel is passed
>> control, perhaps it's not that serious?
>
> The kernel will not be to re-init the eMMC... quite serious. :-)
>
Not unless your board files flag the supplies accordingly, always_on,
and the bootloader sent eMMC the "deadly command seq" ;)
