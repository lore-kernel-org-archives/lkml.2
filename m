Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2KCTdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:33:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47016 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2KCTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EAB973D@DBDE01.ent.ti.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
	<CAD=GYpZ9w=D55G9DOiMqZ4BCGGdGszsgG3fumHUGZ12xx+TKjw@mail.gmail.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB973D@DBDE01.ent.ti.com>
Date: Sat, 3 Nov 2012 14:32:59 -0500
Message-ID: <CAD=GYpYuyfGuEgAWJyE2nkKx4GEsm=eDYAhV966sWVLbEPaqYQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
From: Joel A Fernandes <agnel.joel@gmail.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "Porter, Matt" <mporter@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gururaja,


On Wed, Oct 31, 2012 at 12:39 AM, Hebbar, Gururaja
<gururaja.hebbar@ti.com> wrote:
> On Wed, Oct 31, 2012 at 01:58:32, Joel A Fernandes wrote:
>> Hi Gururaja,
>>
>> On Mon, Oct 29, 2012 at 10:45 AM, Hebbar, Gururaja
>> <gururaja.hebbar@ti.com> wrote:
>> > Matt,
>> >
>> > On Wed, Oct 10, 2012 at 20:00:49, Porter, Matt wrote:
>> >> 6ea74cb ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
>> >> exposes a bug in the AM33XX clock data for mcasp. After moving to
>> >> clk_get() usage, the _init() of all registered hwmods fails on mcasp0
>> >> due to incorrect clock data causing clk_get() to fail. This causes all
>> >> successive hwmods to fail to _init() leaving them in a bad state.
>> >>
>> >> This patch updates the mcasp clock entries so clk_get() will succeed.
>> >> It is tested on BeagleBone and is needed for 3.7-rc1 to fix AM33xx
>> >> boot.
>> >
>> >
>> > I want to test Audio on AM335x Evm with your EDMA patches. I have few
>> > patches for AM335x.
>> > Can you share the link to the repo & branch on which I need to rebase?
>> > The patches are related to mcasp dt node, mcasp pinmux in dt, etc...
>> >
>>
>> I was wondering about the status of following patches you wrote, not
>> added to mainline yet:
>>
>> (1)
>>  ASoC: Davinci: machine: Add device tree binding
>> https://patchwork.kernel.org/patch/1380511/  - will this be resubmitted?
>
> There was no review comments for V3 I submitted.
>
>>
>> (2)
>> ASoC: AM33XX: Add support for AM33xx SoC Audio
>> https://github.com/joelagnel/linux-kernel/commit/973cfb48bdb70018b3869a21595bde8630efb29d
>
> I want to re-submit both the patches along with 2 more patch-set [1]. I am
> waiting for Matt Porters to reply with his recent branch, so that I can do
> a final test and re-submit.
>
> [1].
> arm/dts: Add tlv320aic3x codec DT data to am335x-evm.dts
> arm/dts: add mcasp1 dt node to am335x-evm.dt
> ASoC: davinci-mcasp: Add pinctrl support
> arm/dts: AM33XX: setup pinctrl for mcasp1 on am335x-evm
>

Thanks, I think I have all of your patches now in my tree, I made a
few more changes to make it compile and run for me on 3.7-rc2

beaglebone_defconfig: Add dummy regulator to init tlv320aic3x
https://github.com/joelagnel/linux-kernel/commit/db5672dfe548d82625cf40ed688d05ba7cee5c93

ASoC: davinci-evm: cpu_dai_of_node has changed to cpu_of_node
https://github.com/joelagnel/linux-kernel/commit/8781c69553d0faf7cec0119e593447f27fdc07e9

I don't get a crash anymore (after correcting mcasp0 base address in
dts), but I still don't get any audio output from the codec. I will
probe the audio signals next week to make sure the I2S output is
correct.

Regards,
Joel
