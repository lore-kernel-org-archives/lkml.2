Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2FYUbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:31:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FYUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:31:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for ocp2scp
Date: Mon, 25 Jun 2012 16:26:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1340370942-23201-1-git-send-email-kishon@ti.com> <CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com> <20120625122449.GA30463@arwen.pp.htv.fi>
In-Reply-To: <20120625122449.GA30463@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206251626.09666.arnd@arndb.de>
X-Provags-ID: V02:K0:okxOslY2v0cQunvvE6kTtmSKsgUjp0vh0Lae2x+JXss
 KXceuJ80RLJ7+d1ONpCK+wFqf3ofEYxVV/aZaxXbW4j/xYbHPB
 CsbJtJOOIYUFBl/5718TPCOFzxr1AHYGqghv0NGEWXsRFw1In/
 4ntEtcoApK+Tjz/qq3MaYtkwwqwFx/Q08H4k65VqQLzCedbf18
 dDRWbw79kGr/BhyI9jFX3YEV3HyNyt1oZ8HZPjdCNGhRTbNCHx
 NPfWpfJM6amma7KJxTPfagACOMR59BZ2fizUUfPFfKR7qR4nYJ
 inr29Wg6peWXmrpIB7xlAPPojcABgPB0lfc0s/w+C+hrnyQjas
 e0dAuFFaCmcu0Qqj6elY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2012, Felipe Balbi wrote:
> > > Can't this live where the scp drivers live?  Actually, where is that at?
> > > Do we have scp drivers?
> > AFAIK, there isn't any driver for scp. But we have a driver for ocp
> > and it is present at arch/arm/mach-omap2/omap_l3_noc.c
> 
> I don't think this deserves a directory of its own. Maybe
> drivers/platform/arm/omap/ ?? the l3_noc is an OMAP-specific
> interconnect and the SCP bus is also an OMAP-specific bus. I don't know
> of any other arch/soc who uses the same interconnect IP as OMAP and the
> same ocp2scp bridge. That bridge was created by TI for all I know.
> 
> Greg, would drivers/platform/arm/omap/ work for you ? We could also move
> the interconnect drivers there.

I really don't like the idea of introducing drivers/platform/arm/ because
very little of the stuff that one would put in there are actually ARM
specific.

I have suggested a drivers/bus/ before and people did not see the need
back then, and we agreed to continue having a directory for each bus,
as we have for the big ones (pci, usb, i2c, spi, ...) and a lot of
simple (amba, rapidio, bcma, ...) or obscure (tc,  vlynq, nubus, ...)
ones.

I think we should reconsider the idea of drivers/bus/ with a file per
bus in there at least for new buses, but doing a new drivers/scp/
would be ok for me if there is enough opposition against the idea
of drivers/bus aggregating different buses.

	Arnd

