Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2ESR0C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:26:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19974 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2ESR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:26:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 10:26:00 -0700
Message-ID: <4FB7D676.9000609@nvidia.com>
Date: Sat, 19 May 2012 22:50:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com> <20120519164134.GT4039@opensource.wolfsonmicro.com> <4FB7D4D8.2050501@nvidia.com>
In-Reply-To: <4FB7D4D8.2050501@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012 10:44 PM, Laxman Dewangan wrote:
> On Saturday 19 May 2012 10:11 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Sat, May 19, 2012 at 07:44:06PM +0530, Laxman Dewangan wrote:
>>> When registering the regulator driver, use the rdev->dev for
>>> getting the regulator device of given supply instead of parent
>>> device.
>> You're providing no motivation for this and it's difficult to see how it
>> improves things.  The class device is dynamically numbered so it's not
>> suitable for specifying supplies on a non-DT system and for a DT system
>> it's not obvious to me that we would want to involve the class device in
>> anything, it requires an additional layer of indirection but that's
>> about it.
> If I dont do this then it will not enter in the following case for
> getting the regulator_dev of supply regulator because dev->of_node is
> null, the tps65910-regulator driver have not set the pdev->dev.ofnode.
>
> static struct regulator_dev *regulator_dev_lookup(struct device *dev,
>                                                     const char *supply,
>                                                     int *ret)
> {
>           /* first do a dt based lookup */
>           if (dev&&  dev->of_node) {
> ::::::::::::::::
>               /* Get the regulator device */
>
>       }
> ::::::::::::::::::
> }
Also in regulator_register we set the of_node as
        rdev->dev.of_node = config->of_node;
         rdev->dev.parent = dev;

Passed config->of_node will only be used if we pass the rdev->dev, not 
rdev->dev.parent

Am I missing anything here in understanding?

