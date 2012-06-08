Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab2FHTaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:30:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12593 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2FHTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:30:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Jun 2012 12:28:02 -0700
Message-ID: <4FD250DB.2090207@nvidia.com>
Date: Sat, 9 Jun 2012 00:52:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com> <4FBBDA97.6000006@wwwdotorg.org> <4FBBDE06.5080806@nvidia.com> <4FC916AC.4060804@wwwdotorg.org>
In-Reply-To: <4FC916AC.4060804@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2012 12:53 AM, Stephen Warren wrote:
>
> We could either augment struct of_regulator_match with an integer ID
> field for each regulator (which would perhaps make it slightly painful
> to write the nodes and keep the IDs matched up), or add a new property
> to each regulator provider node e.g. regulator-id which contained the
> name that the regulator driver knows the regulator as (which would match
> struct of_regulator_match.name), since the existing regulator-name
> property is used for semantically different purposes.
>
> That would result in:
>
>> tps65911: tps65911@2d {
>> 	compatible = "ti,tps65911";
>> 	reg =<0x2d>;
>>
>> 	#gpio-cells =<2>;
>> 	gpio-controller;
>>
>> 	regulators {
>> 		#address-cells =<1>;
>> 		#size-cells =<0>;
>>
>> 		vdd1_reg: regulator@0 {
>> 			reg =<0>;
>> 			regulator-id = "vdd1"; /* Internal name */
>> 			regulator-name = "vdd_1v2_gen"; /* Signal on schematic */
> ...
>> 		};
>>
>> 		vdd2_reg: regulator@1 {
>> 			reg =<1>;
>> 			regulator-id = "vdd2";
>> 			regulator-name = "vdd_1v5_gen";
> ...


So is it fine to go on the above binding?
In this case we need to find the match_regulator based on regulator-id 
rather than by name.


