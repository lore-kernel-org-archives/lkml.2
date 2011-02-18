Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab1BRUUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:20:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1BRUUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:20:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Fri, 18 Feb 2011 21:20:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        khilman@ti.com, magnus.damm@gmail.com
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201102181928.05911.rjw@sisk.pl> <AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com>
In-Reply-To: <AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102182120.29977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 18, 2011, Rabin Vincent wrote:
> On Fri, Feb 18, 2011 at 23:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, February 18, 2011, Rabin Vincent wrote:
> >> On Thu, Feb 17, 2011 at 20:55, Rabin Vincent <rabin@rab.in> wrote:
> >> > This will solve the platform vs AMBA bus, but shouldn't we really be
> >> > aiming for consistent behaviour between these and the other busses such
> >> > as I2C and SPI, which are also usually commonly used on the same
> >> > platforms and are using GENERIC_PM_OPS?
> >> >
> >> > Should we be auditing all platform drivers and then switch platform to
> >> > the GENERIC_PM_OPS?
> >> >
> >> > Or should the two points (1) and (2) be not handled in the bus at all
> >> > and be left to individual drivers (in which case we should audit i2c and
> >> > spi and change GENERIC_PM_OPS)?
> >>
> >> How about something like the below?  If we have something like this, we
> >> can just switch platform to GENERIC_PM_OPS and add the
> >> pm_runtime_want_interaction() (or something better named) call to the
> >> i2c and spi drivers using runtime PM.
> >
> > Why don't we make platform_bus_type behave along the lines of generic ops
> > instead?
> 
> At least drivers/spi/omap2_mcspi.c, drivers/video/sh_mobile_lcdcfb.c and
> drivers/watchdog/omap_wdt.c are some pm_runtime-using drivers which seem
> to do different things in their runtime vs normal suspend/resume
> routines, so forcing platform into the active-on-resume behaviour of the
> generic ops may make some use cases impossible.  Conversion of more OMAP
> drivers to runtime pm appears to be ongoing so I'd imagine we'd be
> seeing more of this.  Perhaps Kevin or Magnus will have a comment here.
> The same thing applies to AMBA drivers.

I see.

> Looking at the i2c drivers using runtime pm in comparison, they all seem
> to be using straightforward UNIVERSAL_PM_OPS-style code with the runtime
> and the system sleep doing the same things.  So maybe we do need to
> treat platform/AMBA different from the I2C/SPI group?

We probably do.

Thanks,
Rafael
