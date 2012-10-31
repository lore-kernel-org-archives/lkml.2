Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2JaRlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:41:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11237 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358Ab2JaRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:41:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Oct 2012 10:41:28 -0700
Message-ID: <50916264.3010107@nvidia.com>
Date: Wed, 31 Oct 2012 23:09:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 3/4] ARM: tegra: dts: cardhu: enable SLINK4
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com> <1351674176-20603-3-git-send-email-ldewangan@nvidia.com> <50915563.40904@wwwdotorg.org>
In-Reply-To: <50915563.40904@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 10:14 PM, Stephen Warren wrote:
> On 10/31/2012 03:02 AM, Laxman Dewangan wrote:
>> Enable SLINK4 and connected device in Tegra30 based
>> platform Cardhu.
>> Setting maximum spi frequency to 25MHz.
>>
>> Spi serial flash is connected on CS1 of SLINK4 on
>> cardhu platform.
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +winbond Winbond Electronics corp.
> That should really be a separate patch that goes through the devicetree
> branch. But I guess it's fairly trivial, so it's not a big deal.
>

Yes, I thought that it should be in separate change. I did same on 
earlier for ISL29028 driver and found that this small change still not 
get merged. Therefore I clubbed this together as it can go without any 
issue.
I believe it is fine to merge vendor-prefix from any tree.


>
>> +		spi-flash@1 {
>> +			compatible = "winbond,w25q32";
>> +			spi-max-frequency =<20000000>;
>> +			reg =<1>;
>> +		};
> Since I have an Atmel flash on my board, I see:
>
> [    1.282958] m25p80 spi32766.1: found at25df321a, expected w25q32
> [    1.289103] m25p80 spi32766.1: at25df321a (4096 Kbytes)
>
> Is there any way around that (the first log line above)?
>
> I suppose the answer is that the DT should reflect the exact flash
> device that's on the board, and perhaps the bootloader should be
> adjusting the DT to reflect the correct value. That's probably complex.
>
> Do you have any idea whether Atmel or Winbond flash is more common, so
> we can at least minimize the number of times this message appears?

I observe that most of cardhu have the winbond. All SQA machine has 
winbond. Also I believe on A04, it is winbond.
Better to go with winbond.


