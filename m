Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2GPG6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:58:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7562 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2GPG57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:57:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 15 Jul 2012 23:57:58 -0700
Message-ID: <5003B996.7070702@nvidia.com>
Date: Mon, 16 Jul 2012 12:19:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/5] mfd: tps6586x: remove gpio support from core driver
References: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>	<1342175967-10087-6-git-send-email-ldewangan@nvidia.com> <CACRpkdZ-zsBKSwyzecOpsWyM0o6-EYQwrqWopzeQm1D0D6TaEg@mail.gmail.com>
In-Reply-To: <CACRpkdZ-zsBKSwyzecOpsWyM0o6-EYQwrqWopzeQm1D0D6TaEg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2012 03:42 AM, Linus Walleij wrote:
> On Fri, Jul 13, 2012 at 12:39 PM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> The GPIO functionality of device tps6586x is added through
>> platform gpio driver and it can be register as the mfd sub
>> device and hence removing the duplicates code which register
>> the gpio functionality from core driver.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> The only thing I worry about is if old defconfig files are now
> missing this config option and then this patch becomes an
> unbisectable showstopper for them because they don't get
> this driver by default anymore.
>
> So please make sure you've grepped around and checked
> that of some platforms defconfig was previously selecting
> the core driver, make sure it selects this driver too for
> the moment, it's better if they later deactivate it
> if they don't need it.

Grep shows that only arm based platform tegra_defconfig is using this 
device.
I have added the change in tegra_defconfig and will send as part of this 
series.
