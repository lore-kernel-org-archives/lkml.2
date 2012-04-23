Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2DWMpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:45:36 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:43067 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab2DWMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:45:34 -0400
Message-ID: <4F954ED6.2040201@stericsson.com>
Date: Mon, 23 Apr 2012 14:45:10 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com> <20120423101804.GA8318@opensource.wolfsonmicro.com> <4F953455.3080002@stericsson.com> <20120423110522.GB8318@opensource.wolfsonmicro.com> <4F95495D.4050508@stericsson.com> <20120423122555.GM8318@opensource.wolfsonmicro.com>
In-Reply-To: <20120423122555.GM8318@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 02:25 PM, Mark Brown wrote:
> On Mon, Apr 23, 2012 at 02:21:49PM +0200, Ulf Hansson wrote:
>> On 04/23/2012 01:05 PM, Mark Brown wrote:
>
>>> To be honest I don't entirely understand what your goal is at the system
>>> level - the current idea is that either the regulator will be marked as
>>> always_on or it should be enabled by a consumer.  What is the scenario
>>> in which neither of these is sufficient?
>
>> The consumer do not want to enable the regulator directly from its
>> device probe routine, it is handled through a scheduled work.
>
>> Moreover the regulator shall not be switched off unless the consumer
>> work decides that this is OK.
>
> Cann you be a bit more concrete?  What is this device and why does it
> have these requirements?  The most obvious thing to do here is to run
> the work in the probe routine.

This issue is related to how eMMC cards is working and powered.

A typical mmc host driver is when finished it's probe routine, trigger 
of a so called mmc_rescan work which is taking care of detecting and 
initializing the eMMC card. It is a quite complicated procedure which 
preferably not to be handled from the host driver's probe function.

If the platform already have booted from the eMMC card, the card is 
already powered an initialized from a bootloader. Cutting the power 
without first notifying the card by sending commands to it, must be 
prevented and also violates the eMMC specification. In the end, it will 
mean that the detect and initialization procedure fails.

Kind regards
Ulf Hansson
