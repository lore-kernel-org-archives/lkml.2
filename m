Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1FXVO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:14:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1FXVOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:14:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Date: Fri, 24 Jun 2011 23:14:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Lord <kernel@teksavvy.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
References: <20110618172537.GH3441@infomag.iguana.be> <201106241655.03637.arnd@arndb.de> <20110624191756.GX23305@infomag.iguana.be>
In-Reply-To: <20110624191756.GX23305@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106242314.37119.arnd@arndb.de>
X-Provags-ID: V02:K0:grVnfQZkmJo+nmhkYmpEPag5/j3a1a99LFQnALy3+fB
 kXLbw7mWUQf9jaDWd/k7es5m43QJD79y0GomK6iWw782BLxLMr
 FOlwA6yjn519iaXHGiT34/o3iYS0GaJvPCCoHRhCPDZzL9XzPM
 /jauEhV9N6UNq+cp1RErH2WsBzNjjSZ7GgrzOdvP9TGtZT3EYo
 K35ddo7IJ3KiLoAmwk/EA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 June 2011, Wim Van Sebroeck wrote:
> > > > This is another tricky thing were developers will always discuss about.
> > > > What you don't want to happen is that the watchdog reboots your system when it does
> > > > an fsck at bootup (for instance because the system rebooted by the watchdog and left
> > > > the filesystem in a dirty state...).
> > > > 
> > > > So it's more complex if you look at the overal system...
> > > 
> > > Sure, but that's got little to do with wanting a kernel parameter to OPTIONALLY
> > > enable a hardware watchdog timer at boot.
> > > 
> > > Filesystem checks are a separate issue, easily worked around in practice.
> > 
> > I agree, it's nice to give system integrators the option to enable the watchdog
> > very early, the problems that Wim mentioned need to be solved in user space
> > but are not a serious limitation.
> 
> I'm definitely not against it and I am sure that we all agree that this is a valid
> option for some drivers (certainly in embedded environments). But for me it has to
> stay an option.

I certainly wouldn't make it the default to enable watchdogs on boot, but having
a generic command line argument in the core seems more appropriate to me than
doing it in the drivers, which would require knowing which driver is responsible.

> FYI: We allready have one driver that does this: w83697hf_wdt.c See commit
> 6fd656012bb8d5c5a4570adc2e630668b0109cb0.

This one is somewhat different because the watchdog is already enabled in
this case on bootup, and the command line option tells the driver not
to disable it if it's already on. I can also see why that may be useful,
but an option to enable it independent of its current state would be more
logical to other drivers that always come up disabled.

Anyway, it's certainly not an important functionality to have, and getting
your patches merged shouldn't wait for it.

	Arnd
