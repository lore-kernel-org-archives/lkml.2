Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2K2XMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 18:12:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33862 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab2K2XMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 18:12:08 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Sivaram Nair <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Topic: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Index: Ac3ODj+EBtR5lNOFQkugojWkudbjXgAASILgAB0lr6A=
Date: Thu, 29 Nov 2012 23:11:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
 <D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu

> >  Enabling RTC HW block depends on the default value of TPS65910
> register.
> >  In some mode, RTC block is disabled by default.(eg. AM3517
> Craneboard)
> >  In this case, RTC_PWDN(RTC power down) bit should be cleared to
> enable
> >  the RTC HW block.
> 
> From the description of RTC_PWDN bit of DEVCTRL_REG in TPS65910 data
> sheet
> it is very evident that the default value of RTC_PWDN is 0.

According to the datasheet(http://www.ti.com/lit/ds/swcs046q/swcs046q.pdf),
the default value RTC_PWDN is 1 which means power down.

The default values are loaded from the EEPROM with BOOT_MODE 0,1 pin connection.
The RTC is disabled by default when BOOT_MODE = 00.
The Craneboard has the BOOT_MODE 00.

You may have other EEPROM settings,
however the official datasheet shows the RTC block is off by default.

Could you check the silicon version number? (0x80 register - JTAGVERNUM_REG)
In my case, the read value is 0x01.

> Probably on "AM3517 Craneboard", some code is running prior to the RTC
> driver
> which might be writing 1 on to this bit. IMO you must disable that
> write operation
> instead of just writing default value into a register.

Thank you for your comment.
I've read the DEVCTRL register (0x3F) in mfd tps65910 driver
as soon as the regmap registration is done, however RTC_PWDN is always 1.
That means the RTC is disabled by default.

Best Regards,
Milo

