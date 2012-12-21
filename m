Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2LUUvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:51:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51117 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2LUUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:51:00 -0500
Message-ID: <50D4CBB0.7080603@wwwdotorg.org>
Date: Fri, 21 Dec 2012 13:50:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial
 controller
References: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com> <50D1F2CB.3090206@wwwdotorg.org> <50D2AD02.6060101@nvidia.com> <50D344E9.70305@wwwdotorg.org> <50D3E320.2090804@nvidia.com>
In-Reply-To: <50D3E320.2090804@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 09:18 PM, Laxman Dewangan wrote:
> On Thursday 20 December 2012 10:33 PM, Stephen Warren wrote:
>> On 12/19/2012 11:15 PM, Laxman Dewangan wrote:
>>> On Wednesday 19 December 2012 10:30 PM, Stephen Warren wrote:
>>>> On 12/18/2012 11:31 PM, Laxman Dewangan wrote:
>>>>> Add APB DMA requestor and serial aliases for serial controller.
>>>>> There will be two serial driver i.e. 8250 based simple serial driver
>>>>> and APB DMA based serial driver for higher baudrate and performace.
...
>>>> This patch seems to do two things:
...
>>>> 2) Add aliases for the serial ports. I have no idea why this is useful.
>>> Serial aliases are added because we want to get the port number like
>>> /dev/ttyTHS0,  /d/ttyTHS2 etc. The uarta should be /dev/ttyTHS0 and
>>> uartc should be /dev/ttyTHS2. The port number can be found using aliases
>>> and of_alias_get_id() in driver file:
>>>
>>> port_number = of_alias_get_id(np, "serial");
>>
>> Oh, I see. I guess the aliases make sense then.
>>
>> But, wouldn't you only add aliases for the specific UARTs that are in
>> use on a particular board (so put them in tegraNN-board.dts) rather than
>> all UARTs on Tegra (i.e. the current patch which puts them into
>> tegraNN.dtsi)?
> 
> I like to have this in tegraN N.dtsi file becasue:
> - This policy is not going to change the board to board. For high speed
> driver the uarta will be ttyTHS0 and uartb ttyTHS1.

Sure it is. Since the board files select which UARTs use the low-speed
driver vs. the high-speed driver by overriding the compatible value,
each board will have a different subset of UARTs which use the high
speed driver and hence which use the aliases. Don't you want to end up
with /dev/ttyHS0 on each board, rather than ending up with a "random"
device node name depending on which UART the board designer picked for
the high speed device?
