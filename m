Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2LRGTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:19:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1409 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2LRGTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:19:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 17 Dec 2012 22:17:17 -0800
Message-ID: <50D00AB9.8090800@nvidia.com>
Date: Tue, 18 Dec 2012 11:48:33 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: tegra: Add OF_DEV_AUXDATA for uart driver in
 board dt
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-4-git-send-email-ldewangan@nvidia.com> <50CF92D5.6090805@wwwdotorg.org>
In-Reply-To: <50CF92D5.6090805@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2012 03:17 AM, Stephen Warren wrote:
> On 12/17/2012 05:08 AM, Laxman Dewangan wrote:
>> Add OF_DEV_AUXDATA for high speed uart controller driver for
>> Tegra20/Tegra30 board dt files.
>> Set the parent clock of uart controller to PLLP.
>> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
>> @@ -94,6 +94,11 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006000, "tegra-uart.0", NULL),
>> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006040, "tegra-uart.1", NULL),
>> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006200, "tegra-uart.2", NULL),
>> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006300, "tegra-uart.3", NULL),
>> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006400, "tegra-uart.4", NULL),
> Instead, can we simply get the clocks from device tree? Prashant, how
> much effort will that be once your clock patches are checked in, or is
> it already part of those patches?

It is not part of rework patches, but I will send a patch for it 
immediately after those patches are accepted upstream.

>> @@ -106,7 +111,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>>   static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
>>   	/* name		parent		rate		enabled */
>>   	{ "uarta",	"pll_p",	216000000,	true },
>> +	{ "uartb",	"pll_p",	216000000,	false },
>> +	{ "uartc",	"pll_p",	216000000,	false },
>>   	{ "uartd",	"pll_p",	216000000,	true },
>> +	{ "uarte",	"pll_p",	216000000,	false },
> Prashant's clock patches remove this table. Please work with him to work
> out how to deal with that.

Laxman,

If you want I can include these entries in current tables.



