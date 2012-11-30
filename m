Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2K3Jcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:32:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9306 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2K3Jcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:32:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 30 Nov 2012 01:32:10 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Sivaram Nair <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Nov 2012 15:02:03 +0530
Subject: RE: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Topic: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Index: Ac3ODj+EBtR5lNOFQkugojWkudbjXgAASILgAB0lr6AAFizmAA==
Message-ID: <D958900912E20642BCBC71664EFECE3E6E187A3D95@BGMAIL02.nvidia.com>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
 <D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
 <A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kim, Milo [mailto:Milo.Kim@ti.com]
> Sent: Friday, November 30, 2012 4:42 AM
> To: Venu Byravarasu
> Cc: Andrew Morton; Samuel Ortiz; a.zummo@towertech.it;
> swarren@wwwdotorg.org; Sivaram Nair; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
> initialization
> 
> Hi Venu
> 
> > >  Enabling RTC HW block depends on the default value of TPS65910
> > register.
> > >  In some mode, RTC block is disabled by default.(eg. AM3517
> > Craneboard)
> > >  In this case, RTC_PWDN(RTC power down) bit should be cleared to
> > enable
> > >  the RTC HW block.
> >
> > From the description of RTC_PWDN bit of DEVCTRL_REG in TPS65910 data
> > sheet
> > it is very evident that the default value of RTC_PWDN is 0.
> 
> According to the
> datasheet(http://www.ti.com/lit/ds/swcs046q/swcs046q.pdf),
> the default value RTC_PWDN is 1 which means power down.

As per the data sheet you pointed, the change you made is correct.
Seems the data sheet got updated recently, as it was shown in the
data sheet top section "REVISED SEPTEMBER 2012".

My data sheet has this field as "REVISED FEBRUARY 2011".

So, here I add my ack to this change.
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com> 

> 
> The default values are loaded from the EEPROM with BOOT_MODE 0,1 pin
> connection.
> The RTC is disabled by default when BOOT_MODE = 00.
> The Craneboard has the BOOT_MODE 00.
> 
> You may have other EEPROM settings,
> however the official datasheet shows the RTC block is off by default.
> 
> Could you check the silicon version number? (0x80 register -
> JTAGVERNUM_REG)
> In my case, the read value is 0x01.
> 
> > Probably on "AM3517 Craneboard", some code is running prior to the RTC
> > driver
> > which might be writing 1 on to this bit. IMO you must disable that
> > write operation
> > instead of just writing default value into a register.
> 
> Thank you for your comment.
> I've read the DEVCTRL register (0x3F) in mfd tps65910 driver
> as soon as the regmap registration is done, however RTC_PWDN is always 1.
> That means the RTC is disabled by default.
> 
> Best Regards,
> Milo

