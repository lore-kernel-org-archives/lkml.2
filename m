Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1EGXRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 19:17:45 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:39318 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1EGXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 19:17:44 -0400
Message-ID: <4DC5D310.8050604@hauke-m.de>
Date: Sun, 08 May 2011 01:17:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Greg KH <greg@kroah.com>,
        =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend Van Spriel <arend@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <4DC56FB9.5000208@hauke-m.de> <BANLkTi=FfjK7obq0hj4TjYZc-GgzTuUC6g@mail.gmail.com> <4DC57425.30206@hauke-m.de> <BANLkTikTarvigU-xZNZikhLyvUWse448Tg@mail.gmail.com> <4DC5805C.2010202@hauke-m.de> <20110507224223.GA2537@broadcom.com>
In-Reply-To: <20110507224223.GA2537@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2011 12:42 AM, Henry Ptasinski wrote:
> On Sat, May 07, 2011 at 10:24:44AM -0700, Hauke Mehrtens wrote:
>> On 05/07/2011 06:51 PM, Rafał Miłecki wrote:
>>> 2011/5/7 Hauke Mehrtens <hauke@hauke-m.de>:
>>>> There is a Ethernet core used on embedded devices with this bus and
>>>> George wrote a driver for the first version of this bus implementation,
>>>> he send to the ML. Most user will use this with some wireless devices so
>>>> I would add linux-wireless@vger.kernel.org. Why does ssb uses netdev ML?
>>>
>>> Thanks, I didn't know about this ethernet driver. Have to check it!
>>> Where was this published? Do you have a thread name?
>>
>> I think he haven't send it to the mailing list, there is a link [0] in
>> some Ticket [1] at OpenWrt. This driver was derived from source code
>> Braodcom have published, but not under a GPL compatible license. It will
>> be nice if Braodcom would allow us to publish a driver under the terms
>> of the GPL for the Ethernet core based on their driver, without writing
>> a full spec of the driver like it was done for b43.
> 
> ...
>>
>> [0] http://www.znau.edu.ua/temp/asus-rt-n16/openwrt-bcm4716-README.txt
>> [1] https://dev.openwrt.org/ticket/6580#comment
> 
> All of of the patches listed in [0] appear to contain GPL-licensed code.  Can
> you provide a pointer to the ethernet driver that you think is not under a
> GPL-compatible license?

I was only able to find the driver George build based on the et driver
as a patch in a patch version. It is patch
999-openwrt4716-ssb-bgmac-mak-driver.patch in
http://www.znau.edu.ua/temp/asus-rt-n16/2011-02-13T23-17/001-openwrt4716-TARGET_brcm4716.patch

This driver is based on the Broadcom et driver from the GPL source
package of the Asus RT-N16. One of the files has this header [0]. This
license does not seam to be compatible with the GPL. Netgear provides
the et driver just in binary format without any source code.

It will be nice if Broadcom is fine when we build and release an
Ethernet driver like 999-openwrt4716-ssb-bgmac-mak-driver.patch using
bcma under the terms of the GPL and using et as a reference. The best
thing would be if you could release the Broadcom et driver under a GPL
compatible license, so we are able to use it as a reference
implementation without any problems.

If you relicense your driver you will probably get a Ethernet driver
based on the bcma bus without any costs. I do not see any problems with
the FCC, if your release this code. Every one how wants to see the
source code already did so, as it is freely available for years now.

Hauke

[0] RT-N16/src/et/sys/etcgmac.c header:
---
Broadcom Gigabit Ethernet MAC (Unimac) core.

This file implements the chip-specific routines for the GMAC core.

Copyright (C) 2009, Broadcom Corporation
All Rights Reserved.

This is UNPUBLISHED PROPRIETARY SOURCE CODE of Broadcom Corporation;
the contents of this file may not be disclosed to third parties, copied
or duplicated in any form, in whole or in part, without the prior
written permission of Broadcom Corporation.
---
