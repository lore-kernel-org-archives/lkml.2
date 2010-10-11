Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0JKJC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:02:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0JKJC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:02:28 -0400
Date: Mon, 11 Oct 2010 10:02:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101011090212.GA27153@n2100.arm.linux.org.uk>
References: <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com> <20101011083508.GW29673@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101011083508.GW29673@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:35:08AM +0200, Uwe Kleine-König wrote:
> Alternatively when calling fixup only after parse_tags in setup_arch()
> it worked.  But I guess this change is not for discussion.
> OTOH I wonder why fixup gets passed meminfo.  It's not very useful if
> it's not yet filled.

Because, rather than pass in ATAGs or set the memory on the command line,
they instead wanted to hard-code it in C - something which still happens
today:

arch/arm/mach-msm/board-halibut.c
arch/arm/mach-msm/board-mahimahi.c
arch/arm/mach-msm/board-sapphire.c
arch/arm/mach-msm/board-trout.c
arch/arm/mach-pxa/eseries.c
arch/arm/mach-pxa/spitz.c
arch/arm/mach-s3c2412/mach-smdk2413.c
arch/arm/mach-s3c2412/mach-vstms.c
arch/arm/mach-tegra/board-harmony.c

This is part of the on-going pain of poor quality boot loaders.
