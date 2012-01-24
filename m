Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2AXM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:26:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2AXM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:26:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Date: Tue, 24 Jan 2012 12:25:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        gwingerde@gmail.com, larry.finger@lwfinger.net, davem@davemloft.net,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com> <CAOMZO5AO8TBm+C8LX97j=0SHUXEfcqb+VykBZhu8-ruazWD_3A@mail.gmail.com> <20120124034859.GB17869@kroah.com>
In-Reply-To: <20120124034859.GB17869@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241225.59828.arnd@arndb.de>
X-Provags-ID: V02:K0:bpIjjs71T5km810gRbJWEAiYiL3a1IeuxDXub0jvgc1
 x1VBTbipdIdGqDutyuWcBVLtnAAx12ElgpLK4bWKdzZvnxk4Fu
 rr2m1r3x4BXcVWV7KK/mUmhSdN43wUOWTlhRd2GhbjJB+7+qFj
 I3y90+eDVlxCUF0J6ozcXOQkPDs7PI6dXYL8VBEx0CntTxNtGw
 JWLCdyWdNuqAGjva3aaMKRRCMgWA0vndijMLRqMy2WIsjIsIBQ
 T8BNdf9G4FuvG7qIgsvqWsywwc1pGuwl5fyy9inXQPCpeZiTsA
 HffarM02r4SJn6/x++2WLa9ZSRBhFFGTuH4a/CTIKWByqvXOnR
 /oFaZxu+U0zr+cZfnY6o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 January 2012, Greg KH wrote:
> On Tue, Jan 24, 2012 at 01:17:44AM -0200, Fabio Estevam wrote:
> > On Fri, Jan 6, 2012 at 3:03 AM, Greg KH <greg@kroah.com> wrote:
> > 
> > > Then remove that selection.  Nothing should be depending on a misc
> > > driver,
> > 
> > Yes, this is the exact issue that this patch tries to solve.
> 
> You are seriously going to have to refresh my memory, the patch is many
> weeks old, and long gone from my recall.

It's a version of the patch that led to you and me getting listed as
maintainers. I sent the original version, see the discussion at
http://patchwork.linuxtv.org/patch/316/ with my explanation.

I now saw that my version actually looks better because it removes
a few extra 'select MISC_DEVICES' statements as well. I already
acked Fabio's patch, but maybe it's better to take my patch and
mention Fabio as well in the changelog.

> > Currently all of these are dependent on MISC_DEVICES being set.
> > 
> > source "drivers/misc/c2port/Kconfig"
> > source "drivers/misc/eeprom/Kconfig"
> > source "drivers/misc/cb710/Kconfig"
> > source "drivers/misc/iwmc3200top/Kconfig"
> > source "drivers/misc/ti-st/Kconfig"
> > source "drivers/misc/lis3lv02d/Kconfig"
> > source "drivers/misc/carma/Kconfig"
> > source "drivers/misc/altera-stapl/Kconfig"
> > 
> > With the patch applied it is possible to select all the drivers above
> > and we don't need to select MISC_DEVICES.
> 
> Care to add this to the patch description and resend it as I really
> don't remember what is going on here.

The problem is that we have plenty of drivers that 'select' a configuration
option from drivers/misc/Kconfig:

$ git ls-files drivers/misc/ | grep Kconfig | xargs grep ^config | while read DUMMY OPTION ; do git ls-files | grep Kconfig | grep -v drivers/misc | xargs grep "\<select\>.*\<$OPTION\>" ; done
drivers/platform/x86/Kconfig:   select SENSORS_LIS3LV02D
drivers/memstick/host/Kconfig:  select TIFM_CORE
drivers/mmc/host/Kconfig:       select TIFM_CORE
drivers/media/video/cx23885/Kconfig:    select ALTERA_STAPL
drivers/mmc/host/Kconfig:       select CB710_CORE
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-davinci/Kconfig:  select EEPROM_AT24
arch/arm/mach-s3c2440/Kconfig:  select EEPROM_AT24
arch/unicore32/Kconfig: select EEPROM_AT24
drivers/net/ethernet/8390/Kconfig:      select EEPROM_93CX6
drivers/net/ethernet/micrel/Kconfig:    select EEPROM_93CX6
drivers/net/wireless/Kconfig:   select EEPROM_93CX6
drivers/net/wireless/rt2x00/Kconfig:    select EEPROM_93CX6
drivers/net/wireless/rt2x00/Kconfig:    select EEPROM_93CX6
drivers/net/wireless/rt2x00/Kconfig:    select EEPROM_93CX6
drivers/net/wireless/rt2x00/Kconfig:    select EEPROM_93CX6
drivers/net/wireless/rtl818x/Kconfig:   select EEPROM_93CX6
drivers/net/wireless/rtl818x/Kconfig:   select EEPROM_93CX6
drivers/staging/rtl8187se/Kconfig:      select EEPROM_93CX6
drivers/net/wimax/i2400m/Kconfig:       select IWMC3200TOP
drivers/net/wireless/iwmc3200wifi/Kconfig:      select IWMC3200TOP
drivers/media/radio/wl128x/Kconfig:     select TI_ST if NET && GPIOLIB

If MISC_DEVICES is disabled, this causes a build-time warning about missing
dependencies in a select statement. Some people have resorted to adding
'select MISC_DEVICES', but that has the unintended side-effect of unhiding
all other misc drivers when one of the dependent options is enabled.

	Arnd
