Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2ETMPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:15:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13074 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2ETMPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:15:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 20 May 2012 05:15:16 -0700
Message-ID: <4FB8DF1B.5080206@nvidia.com>
Date: Sun, 20 May 2012 17:40:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <4FB7D4D8.2050501@nvidia.com> <4FB7D676.9000609@nvidia.com> <20120519174052.GX4039@opensource.wolfsonmicro.com> <4FB7DEB0.3040001@nvidia.com> <20120519182658.GB4039@opensource.wolfsonmicro.com> <4FB7EE84.7090704@nvidia.com> <20120519205055.GA16590@opensource.wolfsonmicro.com> <4FB80CEE.4050201@nvidia.com> <20120519231347.GD16590@opensource.wolfsonmicro.com> <4FB89E6D.7000206@nvidia.com> <20120520090112.GE16590@opensource.wolfsonmicro.com>
In-Reply-To: <20120520090112.GE16590@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2012 02:31 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, May 20, 2012 at 01:04:05PM +0530, Laxman Dewangan wrote:
>
>>          ldo2_reg: ldo2 {
>>              ::::::::
>>              /** regulatr entry */
>>              ::::::::::::
>>              ldo2-supply =<&ldo1_reg>; /* So ldo1 supply the ldo2. */
> This mapping should be moved up to the chip top level; this is just like
> any other supply for the chip.
>

Ok, After moving this mapping (ldo2-supply = <&ldo1_reg>;) to top level 
under tps65911,  then it worked without core driver changes.
Becasue at this time, the ldo2->desc->supply_name = "ldo2" get find on 
the chip level node and then it return the regulator node properly.


>> ldo1 registration went fine.
>> During ldo2 registration, I passed the regulator_desc->supply_name as ldo2.
> I'd be somewhat surprised if this is what the pin is actually called,
> idiomatically the supply name should be whatever the pin is named on the
> chip.
Yes, I need to add the code in tps65911-regulator.c to use the proper 
pin name as per datasheet for looking for input supply. Like "vcc3" is 
the pin name for ldo6,ldo7 and ldo8 supply and hence look for 
"vcc3-supply" in the chip level rather than "ldo6-supply" or 
"ldo7-supply" etc.
I will post the patch for these changes.
