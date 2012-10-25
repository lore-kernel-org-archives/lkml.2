Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946082Ab2JYOJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:09:42 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34957 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945971Ab2JYOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:09:39 -0400
Date: Thu, 25 Oct 2012 16:09:28 +0200
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
Message-ID: <20121025160928.53daf18a@skate>
In-Reply-To: <201210251346.41596.arnd@arndb.de>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
	<201210251127.36960.arnd@arndb.de>
	<20121025134352.16a8ef81@skate>
	<201210251346.41596.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Oct 2012 13:46:41 +0000, Arnd Bergmann wrote:

> > Seems like the driver is too lazy and allocates everything coherent
> > to avoid the hassle of doing dma_map/dma_unmap operations when
> > needed, but I haven't looked in details at the driver yet to see if
> > it would be possible to switch those DMA coherent allocations into
> > non-coherent allocations + appropriate calls to the DMA operations.
> 
> Using coherent allocations is fine, I was wondering whether they need
> to be atomic or not.

You're raising a good point here: all the dma_pool_alloc()
allocations done by sata_mv are GFP_KERNEL. So why are we having
problems with the /atomic/ coherent pool size? Is it the libata core
that's doing GFP_ATOMIC DMA coherent allocations. It doesn't seem so.
Something's odd.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
