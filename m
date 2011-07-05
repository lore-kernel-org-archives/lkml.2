Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1GELnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:43:20 -0400
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:56943 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932242Ab1GELnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:43:19 -0400
Date: Tue, 5 Jul 2011 07:32:29 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110705053229.GC27909@game.jcrosoft.org>
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
 <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
 <4E0B43BA.803@atmel.com>
 <201107021149.41703.arnd@arndb.de>
 <4E118679.4090908@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E118679.4090908@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11929753940047670124
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:23 Mon 04 Jul     , Nicolas Ferre wrote:
> Le 02/07/2011 11:49, Arnd Bergmann :
> > On Wednesday 29 June 2011 17:24:42 Nicolas Ferre wrote:
> >>> Here are a few questions:
> >>> i) The drivers you're willing to send, are those for Atmel's IPs or are
> >>>       the IPs sourced from some other company ?
> >>> ii) Even if they are Atmel-specific, do you see the possibility of Atmel
> >>>       licensing them ?
> >>> iii) Does your driver current depend on asm/ or mach/ headers ?
> >>> iv) Is there a generic header which you could use instead of asm/ mach/ ?
> >>
> >> I just want to hide drivers that are not relevant for others: I have the feeling
> >> that it is a good practice. This tiny patch will ease this during my publication
> >> flow. Do you seriously care?
> > 
> > I think Felipe is right on this one, but both views are common in the kernel
> > today: Some people want dependencies to mean "you cannot build this driver
> > unless the dependencies are fulfilled", others like them more broadly to
> > mean "there is no point to ever enable this driver because I know you won't
> > need it".
> > 
> > Both views are understandable, but I favor the first one because
> > 
> > * it's the more common view these days and we should be consistent
> > 
> > * it exposes drivers to more build testing. If something changes in
> >   the kernel that exposes new warnings in your driver or causes a
> >   build error, that is more likely to get fixed when more people
> >   find it by doing allyesconfig or randconfig builds.
> > 
> > * If there is an actual build dependency between the driver and the
> >   platform that causes you to need the explicit Kconfig depends, that
> >   is in many cases a hint that the driver author is doing something
> >   wrong, like hardcoding MMIO addresses or referencing custom
> >   symbols exported by the platform.
> > 
> > I don't think anyone really objects your patch to introduce the extra
> > Kconfig symbol, but I'd hope that we can eventually get a consensus
> > on the idea that you shouldn't use Kconfig dependencies based on
> > whether a driver is relevant or not.
> 
> Arnd, Felipe,
> 
> You have convinced me.
> But I will have to remove the other dependencies that I mentioned before
> in the thread.
> 
> We can drop this patch.
I prefer to hide the platform specific driver other wise we will have a huge
menu entry in Kconfig with unrelated drivers that can not be used at all on
the selected mach

This is really annoying

Best Regards,
J.
