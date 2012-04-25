Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2DYPor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:44:47 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51660 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab2DYPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:44:45 -0400
Message-ID: <4F981BDE.4050906@stericsson.com>
Date: Wed, 25 Apr 2012 17:44:30 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>	<20120423101804.GA8318@opensource.wolfsonmicro.com>	<4F953455.3080002@stericsson.com>	<20120423110522.GB8318@opensource.wolfsonmicro.com>	<4F95495D.4050508@stericsson.com>	<4F954ED6.2040201@stericsson.com>	<20120423180140.GR8318@opensource.wolfsonmicro.com> <CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
In-Reply-To: <CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:34 PM, Jassi Brar wrote:
>> On Mon, Apr 23, 2012 at 02:45:10PM +0200, Ulf Hansson wrote:
>>
>>> If the platform already have booted from the eMMC card, the card is
>>> already powered an initialized from a bootloader. Cutting the power
>>> without first notifying the card by sending commands to it, must be
>>> prevented and also violates the eMMC specification. In the end, it
>>> will mean that the detect and initialization procedure fails.
>>
>   Shouldn't the bootloader be responsible for ensuring MMC is
> put down after using it and before passing control to the kernel.

This is kind of complicated. eMMC is powered by two regulators. VCC and 
VCCQ. Cutting VCC uncontrolled is not allowed. If doing so anyway there 
is two options to recover.

1. Cut VCCQ as well and do full reinit of the eMMC
2. Pull a hw-reset pin to the eMMC and do a full reinit of the eMMC.

In some cases neither is possible due to HW constraints. Thus we have to 
make sure VCC is not cut.

>
>   Even if the bootloader didn't power off properly, unless there is
> some outstanding data to be written when the kernel is passed
> control, perhaps it's not that serious?

The kernel will not be to re-init the eMMC... quite serious. :-)

Kind regards
Ulf Hansson
