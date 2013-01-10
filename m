Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3AJELl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 23:11:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40987 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694Ab3AJELj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 23:11:39 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "tony@atomide.com" <tony@atomide.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH 0/7] HWMOD fixes for AM33xx PWM submodules and device
 tree nodes.
Thread-Topic: [PATCH 0/7] HWMOD fixes for AM33xx PWM submodules and device
 tree nodes.
Thread-Index: AQHN6Ox8H29jkAk/HUikV9JhCxf465hB+/7Q
Date: Thu, 10 Jan 2013 04:10:22 +0000
Deferred-Delivery: Thu, 10 Jan 2013 04:10:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5A503@DBDE01.ent.ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jan 02, 2013 at 18:54:47, Philip, Avinash wrote:
> This patch series is being part of [1] and resubmitting on top of 3.8-rc1 to
> make it to 3.9.
> 
> In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
> PWM subsystem. All these submodules shares the resources (clock) & has
> a clock gating register in PWM Subsystem. So a parent PWM subsystem
> driver is created. To support PWM subsystem driver, parent child
> relation is created in HWMOD entry in patch #2.
> 
> In addition EHRPWM module requires explicit clock gating from control
> module. Hence add clock node for tbclk handling in patch #4.
> 
> Patch #3 to support common clock migration for AM33xx.
> 
> Also Device tree nodes populated to support parent child relation
> between PWMSS, ECAP & EHRPWM submodules (patch #5, 6 & 7).
> 
> This patch series based on linux_omap/master [2] and tested for
> backlight with ECAP on AM335x-evm & AM335x-evmsk.

Are there any reviews on this patch series?
This patch set is required for LCD backlight work based on ECAP PWM
in am335x-evm & am335x-evmsk.

Thanks
Avinash

> 
> 1. https://lkml.org/lkml/2012/11/27/120
> 2. http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=commit;h=c4e2e79ff7c9f4fdad7da432c6b449121cc3033e
> 
> Philip Avinash (7):
>   ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem HWMOD entries
>   ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
>     subsystem
>   pwm: pwm-tiehrpwm: Update the clock handling of pwm-tiehrpwm driver
>   ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
>   ARM: dts: AM33XX: Add PWMSS device tree nodes
>   ARM: dts: AM33XX: Add PWM backlight DT data to  am335x-evm
>   ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk
> 
>  arch/arm/boot/dts/am335x-evm.dts           |   23 ++
>  arch/arm/boot/dts/am335x-evmsk.dts         |   23 ++
>  arch/arm/boot/dts/am33xx.dtsi              |   84 ++++++
>  arch/arm/mach-omap2/cclock33xx_data.c      |   30 +++
>  arch/arm/mach-omap2/control.h              |    8 +
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  390 ++++++++++++++++++----------
>  drivers/pwm/pwm-tiehrpwm.c                 |    4 +-
>  7 files changed, 417 insertions(+), 145 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> 

