Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3AJPeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:34:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:19041 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3AJPeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:34:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,444,1355126400"; 
   d="scan'208";a="189781094"
Date: Thu, 10 Jan 2013 15:54:15 +0000
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] goldfish: add the goldfish virtual bus
Message-ID: <20130110155415.52920a41@bob.linux.org.uk>
In-Reply-To: <201301092230.40331.arnd@arndb.de>
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
	<20130109142305.9239.37581.stgit@bob.linux.org.uk>
	<201301092230.40331.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe drivers/bus would be more appropriate though. Every platform
> handles platforms differently, and x86 seems to be the only one that
> likes the model of putting stuff under drivers/platform.

I'm fine with that and I agree - it is a bus.

> __devinit/__devexit are going away, so you can skip adding them
> for new code.

I'll strip those out of the upstream version

> > +module_init(goldfish_pdev_bus_init);
> > +module_exit(goldfish_pdev_bus_exit);
> 
> The module_platform_driver() macro takes care of this.

Will change to that.

> 
> > +static struct resource goldfish_pdev_bus_resources[] = {
> > +	{
> > +		.start  = GOLDFISH_PDEV_BUS_BASE,
> > +		.end    = GOLDFISH_PDEV_BUS_BASE +
> > GOLDFISH_PDEV_BUS_END - 1,
> > +		.flags  = IORESOURCE_IO,
> > +	},
> > +	{
> > +		.start	= GOLDFISH_PDEV_BUS_IRQ,
> > +		.end	= GOLDFISH_PDEV_BUS_IRQ,
> > +		.flags	= IORESOURCE_IRQ,
> > +	}
> > +};
> > +
> > +struct platform_device goldfish_pdev_bus_device = {
> > +	.name = "goldfish_pdev_bus",
> > +	.id = -1,
> > +	.num_resources = ARRAY_SIZE(goldfish_pdev_bus_resources),
> > +	.resource = goldfish_pdev_bus_resources
> > +};
> > +
> > +static int __init goldfish_init(void)
> > +{
> > +	return platform_device_register(&goldfish_pdev_bus_device);
> > +}
> > +device_initcall(goldfish_init);
> 
> This is the part that I think should actually be part of the
> architecture tree.

Thinking about it a bit I agree. We still end up needing an
architectural header for early console and the like eventually but it
does eliminate much of the rest.

I'll rework it that way.

Alan
