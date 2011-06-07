Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1FGTQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:16:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1FGTQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:16:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Tue, 7 Jun 2011 21:16:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
        akpm@kernel.org, Deepak Saxena <dsaxena@linaro.org>,
        linux-console@vger.kernel.org, greg@kroah.com,
        Timur Tabi <timur@freescale.com>
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106070908.16301.arnd@arndb.de> <4DEE567E.7080102@tilera.com>
In-Reply-To: <4DEE567E.7080102@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106072116.21469.arnd@arndb.de>
X-Provags-ID: V02:K0:oRtt+KZLRx/VEnaavSghDv1Ku5KUv7OiKNT+LSHIj1r
 l/3SFDy6tsAG4pZWRz+n3iAAzsn12OIH3wSzFrXI7Q6tBW7kfq
 ayrHPbV88ue/H7Crt2wvyUJtZOfsG3c+7ACgPFVOW7oKkOXJzX
 MizmYHPolUEh2PyXVIWv8uqLwmw7smOs501rH6+iiVlkFkqKDe
 8EPaDiKK7WankUR7c6kLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011 18:49:02 Chris Metcalf wrote:
> > You can probably argue that the tile drivers do fit in here as long as
> > they are specific to the hypervisor and not to some SOC specific hardware.
> 
> Can you clarify that?   I think you're contrasting something like an ARM
> core that was licensed and put in a SoC by some random vendor, and you
> could have an endless stream of drivers for that case.  The Tilera core
> isn't being licensed; it's sold more like an Intel chip with a fixed set of
> interfaces available only from Tilera.  The particular interface in
> question here is SPI, and the core itself knows how to boot the chip over
> SPI by finding an SPI ROM and reading the boot stream out of it directly
> after power-up.
> 
> So does that match with your model of "drivers/platform/tile"?  Maybe we
> have a winner!  :-)

I'm not really against drivers/platform/tile for this, the only potential
problem that I see with this is that having more stuff in drivers/platform
might lead to having even more other stuff in there that should really
go into another place.

Obviously, if the device is a raw SPI host, the driver should actually go
into drivers/spi/spi_tile.c rather than drivers/platform/tile/spi.c.

For the spi flash driver that goes through the hypervisor abstraction,
I think drivers/virt/tile would be better than driver/platform/tile,
but we should really have a new "abstract flash character driver" subsystem
for that.

	Arnd
