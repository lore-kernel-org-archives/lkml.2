Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2HILKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:10:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9084 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2HILKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:10:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 04:10:16 -0700
Message-ID: <50239700.5020401@nvidia.com>
Date: Thu, 9 Aug 2012 16:24:56 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: dt: tegra: cardhu: add entry for regulators
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com> <50229F6C.10802@wwwdotorg.org>
In-Reply-To: <50229F6C.10802@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012 10:48 PM, Stephen Warren wrote:
> On 08/08/2012 12:48 AM, Laxman Dewangan wrote:
>> This patch series add the PMIC and fixed regulators for
>> cardhu board. There is multiple versions of cardhu baord named
>> as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
>> Cardhu A02 and A04 have different sets of GPIO for regualtors.
>> The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
>> This patch series split the cardhu dts file to cardhu-a02 and
>> carchu-a04 and then add entry for different fixed regualtors.
> With this series, I see the following warnings:
>
> tps65910 4-002d: VMBCH-Threshold not specified
> tps65910 4-002d: VMBCH2-Threshold not specified
>
This is noise from driver. The vmbch entries are optional as per 
document and so should not throw warning. Either fix will go to driver 
or with documentation file and then on DT. Will work on  this as 
independent patch, atleast not with this series.


> I also see the following error:
>
> vdd_sdmmc1: Failed to request enable GPIO31: -16
> reg-fixed-voltage c.regulator: Failed to register regulator: -16
> reg-fixed-voltage: probe of c.regulator failed with error -16
>

The sdhci node take the gpio as power-gpio and conflict with this 
regulator gpio. I dropped the vdd_sdmmc1 as sdhci driver need to change 
accordingly to handle deferred probe.
Will add registration of that file later.

> ... because both the existing SDHCI node and the new "vdd_sdmmc1_reg:
> regulator@12" node both use the same GPIO.
>
> I also don't see "pex_hvdd_3v3_reg: regulator@5" being created, for
> reasons I haven't tracked down.

The issue is comment was not closed. Fixed it in next patch.

> Note that I have a Cardhu A02, although all the issues are with
> regulators in the common file.
>
> Can you please fix these, roll in the fixes for the board ID comment
> issues I mentioned before, retest to ensure there are no errors and that
> all regulators get created as expected, and resubmit.

I fixed as per above details and did not observe any failure on my testing.

