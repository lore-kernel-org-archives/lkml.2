Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2K3Jqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:46:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34709 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2K3Jqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:46:39 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v5 00/12] Support for AM33xx PWM Subsystem
Thread-Topic: [PATCH v5 00/12] Support for AM33xx PWM Subsystem
Thread-Index: AQHNzHv7Ty8Nkugw8U6SPNsEAlmivpf+8gOAgAMaLbA=
Date: Fri, 30 Nov 2012 09:45:13 +0000
Deferred-Delivery: Fri, 30 Nov 2012 09:44:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA0E480@DBDE01.ent.ti.com>
References: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
 <20121128142101.GB21042@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121128142101.GB21042@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 19:51:01, Thierry Reding wrote:
> On Tue, Nov 27, 2012 at 02:18:05PM +0530, Philip, Avinash wrote:
> > In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
> > PWM subsystem. All these submodules shares the resources (clock) & has
> > a clock gating register in PWM Subsystem. This patch series creates a
> > parent PWM Subsystem driver to handle access synchronization of shared
> > resources & clock gating from PWM Subsystem configuration space.
> > Also Device tree nodes populated to support parent child relation
> > between PWMSS, ECAP & EHRPWM submodules.
> > In addition EHRPWM module requires explicit clock gating from control
> > module & is handled by patch #6 & 7.
> > 
> > As suggested by  Thierry for handling clock gating for PWM submodules
> > should handle with a global function. This requires config space
> > handling done independent from driver and is done at parent driver.
> > 
> > So the parent<->child relation adopted to handle
> > 1. pm runtime synchronization
> > 2. PWM subsystem common config space clock gating for PWM submodules.
> > 
> > Patches supports
> > - Driver support for parent child relation handled patch #1
> > - HWMOD data correction in EPWMSS at patch #2
> > - Parent child in HWMOD relation handled at patch #3
> > - Optional EHRPWM tb clock in patch #6
> > - Support for TBCLK clock gating at patch #7.
> > - Device tree binding support handled in patch #4,8 
> > - Pinctrl support in patch #5 & 9.
> > - DT node populated in patch #10 ,11 & 12.
> > 
> > This patch series based on omap_dt/for_3.8/dts_part2 and tested
> > on am335x-evm & am335x-evmsk.
> > 
> > This patch series will come under 3 subsystem basically. But sent
> > it in single patch series to have a clearer picture of why the
> > OMAP subsystem changes required.
> > 
> > Patches come under PWM (1,4,5,7,8,9)
> > Patches come under OMAP (2,3,6)
> > Patches come under DT (10,11,12).
> > 
> > It depends on [1]
> > 1. https://gitorious.org/linux-pwm/linux-pwm/commit/83af24027b3df1af5c5a9aa9adcdcfeb3429d3be
> > pwm: Device tree support for PWM polarity
> > 
> > Changes since v3:
> > 	- Rebased on top of omap_dt/for_3.8/dts_part2
> > 	- Add pwm backlight for am335xevm_sk
> > 	- Moved tipwmss.h to pwm-tipwmss.h
> > 
> > Philip, Avinash (12):
> >   PWMSS: Add PWM Subsystem driver for parent<->child relationship
> >   ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem HWMOD entries
> >   ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
> >     subsystem
> >   pwm: tiecap: Add device-tree binding
> >   pwm: pwm-tiecap: pinctrl support
> >   ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
> >   pwm: pwm-tiehrpwm: Adding TBCLK gating support.
> >   pwm: tiehrpwm: Add device-tree binding
> >   pwm: pwm-tiehrpwm: pinctrl support
> >   ARM: dts: AM33XX: Add PWMSS device tree nodes
> >   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
> >   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk
> 
> Patches 1, 4, 5, 7, 8 and 9 applied, with a minor fixup to the subject
> line of patch 1. Thanks.

Thierry,
Thanks for applying the PWM patches.
I will follow up with OMAP community for other patches.

Paul/Benoit,

Is there any way to get HWMOD and DT patches getting accepted in 3.8?
Or should I wait and send rebased patch based on 3.8-rc1?

Thanks
Avinash

> 
> Thierry
> 

