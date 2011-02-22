Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1BVKjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:39:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40619 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1BVKjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=Y/AUc/eXf6wkLfPAdWAt1qA24ZKx50/O6EchYtEeKSkPi0JF8XwMp5cK9y3eDWwi31
         brkIhQuu7FNk5twTga0se67w+c1AcyamZMWAsL+hntYwlggN52SUsXnzcpBAFyxJYz4Y
         buAxqx9AhSSzkA5E5fX1bq0Xp9XmNkQ7x8UDU=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4D637557.2070707@compulab.co.il>
References: <1297786849.2596.13.camel@phoenix> <4D5AB09C.9000106@compulab.co.il>
 <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com> <4D637557.2070707@compulab.co.il>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 22 Feb 2011 18:38:40 +0800
Message-ID: <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/22 Igor Grinberg <grinberg@compulab.co.il>:
> Hi,
>
> On 02/22/11 03:12, Axel Lin wrote:
>
>> Hi Igor,
>>
>>> Also, there is one thing that is not related to this patch, but
>>> if you have the hardware, you need to be concerned with,
>>> is that the vcc_core voltage has to be 1.4V, otherwise your
>>> hardware will be unstable.
>> I don't see any unstable issue on my device.
>> But it seems the vcc_core and vcc_sram fields of pxa3xx_freq_info
>> are not used now.
>
> Indeed, they are not used, because we don't have any DVFS driver for PXA3xx.
> But, the hardware is running regardless of you have the driver or not ;)
> There are other means to make sure the vcc_core voltage is set appropriately:
> 1) could be already set (PMIC default)
> 2) could be set by "Hardware-Controlled Voltage-Change Sequencer" automatically
>   (PXA3xx_DM_Vol_I chapter 6.8.3) if your PMIC is 100% compatible with PXA3xx
>   and PVCR[FVE/PVE] bits set accordingly.
> 3) If your PMIC is for some reason not 100% compatible, then the voltage can be
>   set by regulator API or even by the bootloader.
>
> Anyway, to make sure it is set to the appropriate level, you need to measure it.
> Usually, this line has some capacitors on it, so it shouldn't be a hard task
>
Thanks for the information. I'll check my settings.

> Now, regarding hardware instability:
> I've seen instabilities related to the vcc_core set improperly, but it has never
> showed up that quickly, sometimes it took a week of testing for it to show up.
> But when it shows up, you can see strange things happening, like your DRAM
> is messed or buses fail or the cpu just freezes.
>
>
> Another thing (which could be related to the patch) is the package marking.
> We have PXA3xx SoCs marked A2 stepping, but C624, which means that the
> highest running frequency should not exceed 624MHz.

This means not all PXA310 A2 stepping supports 806Mhz.
Can we differentiate the Cxxx option in software?

> What is your PXA3xx A2 marking in respect to Cxxx option?

Mine is 88AP310-A2-BGK2C806.

Regards,
Axel
