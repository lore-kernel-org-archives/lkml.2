Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2K3AOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:14:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K3AN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:13:59 -0500
Date: Thu, 29 Nov 2012 16:13:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Sivaram Nair <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Message-Id: <20121129161358.9ae29f96.akpm@linux-foundation.org>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
	<D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
	<A874F61F95741C4A9BA573A70FE3998F6418F30B@DQHE02.ent.ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 23:11:37 +0000
"Kim, Milo" <Milo.Kim@ti.com> wrote:

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
> According to the datasheet(http://www.ti.com/lit/ds/swcs046q/swcs046q.pdf),
> the default value RTC_PWDN is 1 which means power down.
> 
> The default values are loaded from the EEPROM with BOOT_MODE 0,1 pin connection.
> The RTC is disabled by default when BOOT_MODE = 00.
> The Craneboard has the BOOT_MODE 00.
> 
> You may have other EEPROM settings,
> however the official datasheet shows the RTC block is off by default.
> 
> Could you check the silicon version number? (0x80 register - JTAGVERNUM_REG)
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

I've merged this patch into -mm for 3.8 along with a note-to-self that
there might still be open issues.  Venu, please let us know if the
above settles things?
