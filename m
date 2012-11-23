Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2KWKne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:43:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53289 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2KWKna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:43:30 -0500
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
Subject: RE: [PATCH v4 00/11] Support for AM33xx PWM Subsystem
Thread-Topic: [PATCH v4 00/11] Support for AM33xx PWM Subsystem
Thread-Index: AQHNx+m7qg64Nt3OLE2rnPs5zTQ1E5f2ATAAgAEw56A=
Date: Fri, 23 Nov 2012 10:42:13 +0000
Deferred-Delivery: Fri, 23 Nov 2012 10:42:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EE9FC@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <20121122211616.GK16716@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121122211616.GK16716@avionic-0098.adnet.avionic-design.de>
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

On Fri, Nov 23, 2012 at 02:46:16, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 06:40:57PM +0530, Philip, Avinash wrote:
> > In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
> > PWM subsystem. All these submodules shares the resources (clock) & has
> > a clock gating register in PWM Subsystem. This patch series creates a
> > parent PWM Subsystem driver to handle access synchronization of shared
> > resources & clock gating from PWM Subsystem configuration space.
> > Also Device tree nodes populated to support parent child relation
> > between PWMSS, ECAP & EHRPWM submodules.
> > In addition EHRPWM module requires explicit clock gating from control
> > module & is handled by patch #2 & 8.
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
> > - Optional EHRPWM tb clock in patch #2
> > - Parent child in HWMOD handled at patch #3
> > - Device tree binding support handled in patch #4, 6 &8
> > - pinctrl support in patch #5 & 7.
> > - DT node populated in patch #9 ,10 & 11.
> > 
> > This patch series based on omap_dt/for_3.8/dts_part2 and tested
> > on am335x-evm & am335x-evmsk.
> > 
> > It depends on [1]
> > 
> > 1. https://lkml.org/lkml/2012/11/21/70
> > pwm: Device tree support for PWM polarity
> > 
> > Changes since v3:
> > 	- Rebased on top of omap_dt/for_3.8/dts_part2
> > 	- Add pwm backlight for am335xevm_sk
> > 	- Moved tipwmss.h to pwm-tipwmss.h
> > 
> > Philip, Avinash (11):
> >   PWMSS: Add PWM Subsystem driver for parent<->child relationship
> >   ARM: am33xx: clk: Add optional clock for EHRPWM
> >   ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
> >     subsystem
> >   pwm: pwm-tiecap: Add device-tree binding support for APWM driver
> >   pwm: pwm-tiecap: pinctrl support
> >   pwm: pwm-tiehrpwm: Add device-tree binding support for EHRPWM driver
> >   pwm: pwm-tiehrpwm: pinctrl support
> >   pwm: pwm-tiehrpwm: Adding TBCLK gating support.
> >   ARM: dts: AM33XX: Add PWMSS device tree nodes
> >   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
> >   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk
> 
> Hi,
> 
> So how do you want to get this merged? Should I take patches 1, 4, 5, 6,
> 7 and 8 while the rest go through some ARM tree? Can we still merge this
> for 3.8?

These patches can go on, as DT node is not populated. Also without patch #3
PWM Subsystem driver won't come and hence the platform devices for ECAP 
& EHRPWM. So there is no issue in getting this merged in PWM subsystem.

> The patches don't seem to have build dependencies on each other
> but how about runtime dependencies?

Patch #3 required for PWM subsystem driver to populate PWM subsystem HWMOD
Entries and DT entries. 
Patch #2 required for EHRPWM to have TBCLK handling. This patch required for
EHRPWM driver functionality. But currently DT node is disabled for EHRPWM.

So the dependency on the entire series is patch #3, for backlight through PWM
ecap.

I will follow up with OMAP subsystem community for getting reviews/ack

Thanks
Avinash

> 
> Thierry
> 

