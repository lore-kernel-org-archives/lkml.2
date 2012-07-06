Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2GFKPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:15:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7507 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GFKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:15:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 06 Jul 2012 03:11:34 -0700
Message-ID: <4FF6B8EE.1030507@nvidia.com>
Date: Fri, 6 Jul 2012 15:37:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: cardhu: add dt entry for PMIC TPS65911.
References: <1341414479-6446-1-git-send-email-ldewangan@nvidia.com> <4FF5E803.7000304@wwwdotorg.org>
In-Reply-To: <4FF5E803.7000304@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2012 12:46 AM, Stephen Warren wrote:
> On 07/04/2012 09:07 AM, Laxman Dewangan wrote:
>> Tegra30 based platform "cardhu" have the power management
>> IC TPS65911 for the regulator.
>> Adding DT entry for this device.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> I recall there were some differences between Cardhu A02 and A04. Does
> this patch apply equally to both?

Yes, this piece is common. I already sent the splitting A02 and A04 
which is having some differences in the fixed regulator GPIOs. It is 
pending for internal review.

> Please have a look at the recent threads re: various Tegra20 boards'
> regulator .dts files, and see the results at:
>
> git://nv-tegra.nvidia.com/user/swarren/linux-2.6 linux-next_common
>
> Most of these comments are driven by comments made in the review of
> those patches.
>
> In the patch description, can you please specify where you got all the
> values from, and any discrepancies.

Ok, I will do.

>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dts b/arch/arm/boot/dts/tegra30-cardhu.dts
>> +				vdd1_reg: regulator@0 {
>> +					reg =<0>;
>> +					regulator-compatible = "vdd1";
>> +					regulator-name = "vdd_1v2_gen";
> It'd be good to list all the signals that these regulators drive
> directly; the schematics "rename" the signals quite a lot.

Will add wherever it is possible.

>> +					regulator-min-microvolt =<  600000>;
>> +					regulator-max-microvolt =<1500000>;
> Similarly, the contraints should list the exact voltage that's required
> of the regulators, not a range. Right now, there is no DVFS in the
> mainline kernel, so even for rails where DVFS could be used in the
> future, we should specify the single voltage we want these rails to run
> at without DVFS for now.
>
Fine, will provide the one voltage.
>> +					regulator-always-on;
>> +					regulator-boot-on;
> These properties aren't in the same order in all the nodes. It'd be nice
> to have them ordered the same way everywhere.
>
> I'm not sure if it really makes sense to specify regulator-boot-on,
> since there's no way to know what SW has run before the kernel which
> might have turned off the regulator; regulator-always-on seems to cover
> all necessary use-cases.

