Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2LTGPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:15:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17803 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2LTGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:15:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 19 Dec 2012 22:15:30 -0800
Message-ID: <50D2AD02.6060101@nvidia.com>
Date: Thu, 20 Dec 2012 11:45:30 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial
 controller
References: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com> <50D1F2CB.3090206@wwwdotorg.org>
In-Reply-To: <50D1F2CB.3090206@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 10:30 PM, Stephen Warren wrote:
> On 12/18/2012 11:31 PM, Laxman Dewangan wrote:
>> Add APB DMA requestor and serial aliases for serial controller.
>> There will be two serial driver i.e. 8250 based simple serial driver
>> and APB DMA based serial driver for higher baudrate and performace.
>>
>> The simple serial driver get enabled with compatible nvidia,tegra20-uart
>> and APB DMA based driver will get enabled with compatible
>> nvidia,tegra20-hsuart.
> This patch seems to do two things:
>
> 1) Add a comment describing how to select the basic or DMA-based driver.
> I can see why this is useful.
>
> 2) Add aliases for the serial ports. I have no idea why this is useful.

Serial aliases are added because we want to get the port number like 
/dev/ttyTHS0,  /d/ttyTHS2 etc. The uarta should be /dev/ttyTHS0 and 
uartc should be /dev/ttyTHS2. The port number can be found using aliases 
and of_alias_get_id() in driver file:

port_number = of_alias_get_id(np, "serial");




