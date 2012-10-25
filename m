Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2JYLoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:44:06 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:33120 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2JYLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:44:04 -0400
Date: Thu, 25 Oct 2012 13:43:52 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/2] arm: mvebu: increase atomic coherent pool size for
 armada 370/XP
Message-ID: <20121025134352.16a8ef81@skate>
In-Reply-To: <201210251127.36960.arnd@arndb.de>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
	<1351086561-13569-2-git-send-email-gregory.clement@free-electrons.com>
	<201210251127.36960.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, 25 Oct 2012 11:27:36 +0000, Arnd Bergmann wrote:
> On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> > For Armada 370/XP we have the same problem that for the commit
> > cb01b63, so we applied the same solution: "The default 256 KiB
> > coherent pool may be too small for some of the Kirkwood devices, so
> > increase it to make sure that devices will be able to allocate their
> > buffers with GFP_ATOMIC flag"
> > 
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> Do you know why the ATA driver needs this? I find it surprising that
> it's necessary, so I'd like to make sure we're not just working around
> a device driver bug here.

The sata_mv driver create dma_pool and allocate objects from them, and
all the memory allocated for dma_pools is allocated using
dma_alloc_coherent(), and I guess the driver is using too much of them.

Seems like the driver is too lazy and allocates everything coherent to
avoid the hassle of doing dma_map/dma_unmap operations when needed, but
I haven't looked in details at the driver yet to see if it would be
possible to switch those DMA coherent allocations into non-coherent
allocations + appropriate calls to the DMA operations.

That said, that's for sure a larger task than just enabling SATA on
Armada 370/XP, so I would advocate to handle this problem separately.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
