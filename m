Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab1F1QS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:18:58 -0400
Received: from 27.98.mail-out.ovh.net ([178.33.105.219]:44120 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758592Ab1F1QRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:17:53 -0400
Date: Tue, 28 Jun 2011 18:02:52 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110628160252.GQ17355@game.jcrosoft.org>
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
 <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
 <4E09C573.2030607@atmel.com>
 <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18351042582673075141
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: Vade Retro 01.322.25 AV+AS Profile: OVH; Bailout: 300; @!Recipients (-100); (-100)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:26 Tue 28 Jun     , Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jun 28, 2011 at 02:13:39PM +0200, Nicolas Ferre wrote:
> > Le 28/06/2011 12:35, Felipe Balbi :
> > > On Tue, Jun 28, 2011 at 01:35:27PM +0200, Nicolas Ferre wrote:
> > >> Add this Kconfig variable to ease the submission of this chip support.
> > >> As this chip/board inclusion is dealayed due to deep consolidation of
> > >> arm/mach-at91 sources, we include this dummy configuration variable to allow
> > >> submission of SAM9x5 related drivers in other subsystems.
> > > 
> > > Why are the drivers even depending on this ? They should be portable
> > > enough. Can you share a few drivers so we have a look ?
> > 
> > Yes sure. The dependence is only on the Kconfig side: I plan to make
> > some drivers dependent on this configuration variable.
> > The goal is to submit the final driver addition without having to send
> > again a correction to the Kconfig after the chip/board support is merged.
> 
> my point is that the drivers shouldn't need that ;-) Are the controllers
> Atmel's specific or are you guys sourcing from somewhere else ?
> 
> > This will ease the submission process at the cost of a two lines dummy
> > patch and will remove interdependence between subsystem trees: it worth
> > it, is not it?
> 
> if you remove any architecture dependency from the driver, why do you
> even need these two lines ? ;-)
> 
> > > IMHO, the whole idea of the consolidation is beyond arch/arm, drivers
> > > should be affected too.
> > 
> > Yes sure, I also understood like this.
> > I will not spread ARCH_AT91SAM9X5 ifdef in driver code...
> 
> yet you will prevent the driver from being easily used by other
> architectures. What will happen is that a certain amount of:
> 
> depends on (ARCH_AT91SAM9X5 || ARCH_FOO || ARCH_BAR || ARCH_BAZ)
no I disagree this is done to allow only the drivers on proper arch

and we do not need the multiple depend we usally create a HAVE_xxx config
that the ARCH select and we just depend on it


Best Regards,
J.
