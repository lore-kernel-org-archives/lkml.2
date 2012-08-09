Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2HILO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:14:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9311 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922Ab2HILO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:14:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 04:14:27 -0700
Message-ID: <502397FC.8070806@nvidia.com>
Date: Thu, 9 Aug 2012 16:29:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: dt: tegra: cardhu: add entry for regulators
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com> <5022A1DA.5000203@wwwdotorg.org>
In-Reply-To: <5022A1DA.5000203@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012 10:58 PM, Stephen Warren wrote:
> On 08/08/2012 12:48 AM, Laxman Dewangan wrote:
>> This patch series add the PMIC and fixed regulators for
>> cardhu board. There is multiple versions of cardhu baord named
>> as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
>> Cardhu A02 and A04 have different sets of GPIO for regualtors.
>> The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
>> This patch series split the cardhu dts file to cardhu-a02 and
>> carchu-a04 and then add entry for different fixed regualtors.
> Two more comments on this patch, sorry for the noise...
>
> 1) With this patch, running "reboot" or "shutdown -r now" no longer
> works; the system hangs. Reboot works fine without this patch, in
> next-20120708.

I tested reboot and it worked fine with me on my patch v2 series.

> 2) U-Boot initializes the LCD, and prints to it. This is left running
> when the kernel is booted, and the kernel doesn't reprogram the HW, so
> the LCD continues to scan out some "random" area of memory. Typically,
> this then gets used and so the LCD shows random patterns. In today's
> linux-next it seems to be turned black though; not sure why that's
> happening. Either way, this patch turns the whole LCD completely white.
> Is that an expected change?

The panel power was not ON and hence the white screen. Fixed it in patch 
V2 to make always ON with boot-on.

