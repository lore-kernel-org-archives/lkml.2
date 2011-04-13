Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab1DMXHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:07:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36544 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab1DMXHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZjYHhoRYIXwpcSPtRbxE4b97lPXYvXnHfEj67fGx3J3N2KGQ7awZoM7oJ88P6aOUik
         5vT6TufJJa/m3+bzJuHxsm8cmqrggPzDQnvFDSySKYVv3M5RgfzZokjBYbGDGtUhQVTE
         jp1a+K/rSTUuqrSZozMKBt5hM7Ln8ElI3n/yo=
MIME-Version: 1.0
In-Reply-To: <BANLkTinXnZzF_1XkdDpuHsL-NWDd03VREw@mail.gmail.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<4DA4AC4B.90409@hauke-m.de>
	<BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
	<BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
	<1302640546.14216.65.camel@dev.znau.edu.ua>
	<BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
	<op.vtvalzu33ri7v4@arend-laptop>
	<BANLkTik6JZ-n3sVjCFK_x1yNRH3_o3_6rg@mail.gmail.com>
	<1302726187.7911.11.camel@dev.znau.edu.ua>
	<BANLkTi=8HEysFXhcv5yn=ErWZkzzqPoSug@mail.gmail.com>
	<BANLkTinXnZzF_1XkdDpuHsL-NWDd03VREw@mail.gmail.com>
Date: Thu, 14 Apr 2011 01:07:17 +0200
Message-ID: <BANLkTinhrpbzv8aHGQeB3Rp4rZuuE8xnbw@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/13 Rafał Miłecki <zajec5@gmail.com>:
> 2011/4/13 Rafał Miłecki <zajec5@gmail.com>:
>> Will comment on that later.
>
> Can we try to decide, how to implement our driver correctly? This
> should be main focus for now. I tried to analyze drivers/amba/, how it
> works, how it relates to our code, Broadcom.
>
> AFAICS AMBA so far is mostly (always?) used for embedded devices with
> pre-defined hardware layout. Let's take as example mach-u300 (just
> some random one). One of the amba_devices it registers is uart0_device
> which has two interesting fields:
> .start = U300_UART0_BASE,
> .end   = U300_UART0_BASE + SZ_4K - 1,
> U300_UART0_BASE == (U300_SLOW_PER_PHYS_BASE+0x3000) == 0xc0013000
> So this mach-u300 is well-specified device, every mach-u300 has uart0
> at 0xc0013000.
>
> It looks every AMBA device (like uart0) has some common fields, like:
> u32 peripherialid0, peripherialid1, peripherialid2, peripherialid3;
> u32 componentid0, componentid1, componentid2, componentid3;
>
> I believe Broadcom's *agent* AKA *wrapper* is comparable to standard
> amba device.
>
> Of course agents/wrappers are not the same for every Broadcom AMBA AXI
> card, so we can not use strict .start and .end declarations and the
> same agents/wrappers for every card. Instead, we have to do scanning
> of EPROM to read info about agents/wrappers.
>
> If someone does not know: every core on Broadcom AMBA AXI card has
> it's agent/wrapper. We access agent/wrapper registers to
> enable/disable/reset core.
>
> So we could scan EPROM for agents/wrappers, register them in AMBA
> driver using our *_core_enable as AMBA's clock management.
>
>
> Please verify if my understanding is correct. I tried to explain
> easily whole situation I just analyzed.
>
> If I'm right: is this really the right path to follow? What about real
> core, like PCIe core, or IEEE core? I guess they are not standard AMBA
> cores, so we can not simply register them. Should we look for clever
> way to connect everything we have with drivers/amba? How to connect
> "real" cores (PCIe, IEEE) with agents?
>
> Please, share how do you see this situation now.

I've done a little more thinking & investigation on this.

First of all, our agent/wrapper cores are real AMBA components. I've
done such a reading:
pr_info("XXX wrapper AXI_PERIPHERIALID0 0x%08X\n", axi_aread32(core,
AXI_PERIPHERIALID0));
pr_info("XXX wrapper AXI_COMPONENTID0 0x%08X\n", axi_aread32(core,
AXI_COMPONENTID0));
for every agent/wrapper.

The result was:
[  362.720551] axi: Switched to core: 0x800
[  362.720519] axi: CC wrapper AXI_PERIPHERIALID0 0x00000069
[  362.720523] axi: CC wrapper AXI_PERIPHERIALID1 0x000000B3
[  362.720527] axi: CC wrapper AXI_PERIPHERIALID2 0x0000003B
[  362.720531] axi: CC wrapper AXI_PERIPHERIALID3 0x00000010
[  362.720535] axi: CC wrapper AXI_COMPONENTID0 0x0000000D
[  362.720539] axi: CC wrapper AXI_COMPONENTID1 0x000000F0
[  362.720542] axi: CC wrapper AXI_COMPONENTID2 0x00000005
[  362.720546] axi: CC wrapper AXI_COMPONENTID3 0x000000B1

[  362.720551] axi: Switched to core: 0x820
[  362.728037] axi: PCIE wrapper AXI_PERIPHERIALID0 0x00000069
[  362.728041] axi: PCIE wrapper AXI_PERIPHERIALID1 0x000000B3
[  362.728045] axi: PCIE wrapper AXI_PERIPHERIALID2 0x0000003B
[  362.728049] axi: PCIE wrapper AXI_PERIPHERIALID3 0x00000010
[  362.728053] axi: PCIE wrapper AXI_COMPONENTID0 0x0000000D
[  362.728056] axi: PCIE wrapper AXI_COMPONENTID1 0x000000F0
[  362.728060] axi: PCIE wrapper AXI_COMPONENTID2 0x00000005
[  362.728064] axi: PCIE wrapper AXI_COMPONENTID3 0x000000B1

[  362.728068] axi: Switched to core: 0x812
[  362.728076] axi: 80211 wrapper AXI_PERIPHERIALID0 0x00000069
[  362.728079] axi: 80211 wrapper AXI_PERIPHERIALID1 0x000000B3
[  362.728083] axi: 80211 wrapper AXI_PERIPHERIALID2 0x0000003B
[  362.728087] axi: 80211 wrapper AXI_PERIPHERIALID3 0x00000010
[  362.728091] axi: 80211 wrapper AXI_COMPONENTID0 0x0000000D
[  362.728095] axi: 80211 wrapper AXI_COMPONENTID1 0x000000F0
[  362.728098] axi: 80211 wrapper AXI_COMPONENTID2 0x00000005
[  362.728102] axi: 80211 wrapper AXI_COMPONENTID3 0x000000B1

Tip:
#define AMBA_CID	0xb105f00d

*So*:
1) We could read info about existing agents/wrappers from EPROM and
register them as amba_devices
2) We could register amba_driver for id 0x103BB369
3) We could register our core-managing functions as clock operators

Problem:
b43 can not be our amba_driver, because this is not the correct layer.
We would need to create separated amba_driver driver for 0x103BB369,
initializing whole stuff (PCIe core, ChipCommon, ChipCommon PMU) *and*
registering new kind of device in the system, identified by manuf, id,
rev and class. That devices would be of course Broadcom cores present
on AMBA, but not AMBA-compatible (not wrappers, they are real AMBA
devices!).

I've also try treating Broadcom cores (not wrappers, which are real
AMBA devices!) as AMBA devices. For that I've tried:
pr_info("80211 AXI_PERIPHERIALID0 0x%08X\n", axi_read32(core,
AXI_PERIPHERIALID0));
Please, note, that this time I used "read32", not "aread32". It means
I was accessing Broadcom core, not AMBA agent/wrapper core. This
operation hanger my machine right away.

-- 
Rafał
