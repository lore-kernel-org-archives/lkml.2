Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1BVIfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:35:51 -0500
Received: from compulab.co.il ([67.18.134.219]:59885 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1BVIfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:35:46 -0500
Message-ID: <4D637557.2070707@compulab.co.il>
Date: Tue, 22 Feb 2011 10:35:35 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
References: <1297786849.2596.13.camel@phoenix> <4D5AB09C.9000106@compulab.co.il> <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com>
In-Reply-To: <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/22/11 03:12, Axel Lin wrote:

> Hi Igor,
>
>> Also, there is one thing that is not related to this patch, but
>> if you have the hardware, you need to be concerned with,
>> is that the vcc_core voltage has to be 1.4V, otherwise your
>> hardware will be unstable.
> I don't see any unstable issue on my device.
> But it seems the vcc_core and vcc_sram fields of pxa3xx_freq_info
> are not used now.

Indeed, they are not used, because we don't have any DVFS driver for PXA3xx.
But, the hardware is running regardless of you have the driver or not ;)
There are other means to make sure the vcc_core voltage is set appropriately:
1) could be already set (PMIC default)
2) could be set by "Hardware-Controlled Voltage-Change Sequencer" automatically
   (PXA3xx_DM_Vol_I chapter 6.8.3) if your PMIC is 100% compatible with PXA3xx
   and PVCR[FVE/PVE] bits set accordingly.
3) If your PMIC is for some reason not 100% compatible, then the voltage can be
   set by regulator API or even by the bootloader.

Anyway, to make sure it is set to the appropriate level, you need to measure it.
Usually, this line has some capacitors on it, so it shouldn't be a hard task

Now, regarding hardware instability:
I've seen instabilities related to the vcc_core set improperly, but it has never
showed up that quickly, sometimes it took a week of testing for it to show up.
But when it shows up, you can see strange things happening, like your DRAM
is messed or buses fail or the cpu just freezes.


Another thing (which could be related to the patch) is the package marking.
We have PXA3xx SoCs marked A2 stepping, but C624, which means that the
highest running frequency should not exceed 624MHz.
What is your PXA3xx A2 marking in respect to Cxxx option?

-- 
Regards,
Igor.

