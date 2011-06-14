Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1FNMQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:16:30 -0400
Received: from smtp.nokia.com ([147.243.128.24]:30879 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab1FNMQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:16:26 -0400
Subject: Re: [RFC PATCHv5 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <874o3tmqhk.fsf@ti.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1307713124-3946-3-git-send-email-carlos.chinea@nokia.com>
	 <874o3tmqhk.fsf@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 15:12:24 +0300
Message-ID: <1308053544.2819.38115.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:21 -0700, ext Kevin Hilman wrote:
> Carlos Chinea <carlos.chinea@nokia.com> writes:
> 
> > Introduces the OMAP SSI driver in the kernel.
> >
> > The Synchronous Serial Interface (SSI) is a legacy version
> > of HSI. As in the case of HSI, it is mainly used to connect
> > Application engines (APE) with cellular modem engines (CMT)
> > in cellular handsets.
> >
> > It provides a multichannel, full-duplex, multi-core communication
> > with no reference clock. The OMAP SSI block is capable of reaching
> > speeds of 110 Mbit/s.
> >
> > Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> > ---
> >  arch/arm/mach-omap2/ssi.c             |  134 +++
> >  arch/arm/plat-omap/include/plat/ssi.h |  204 ++++
> >  drivers/hsi/controllers/omap_ssi.c    | 1852 +++++++++++++++++++++++++++++++++
> >  3 files changed, 2190 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-omap2/ssi.c
> >  create mode 100644 arch/arm/plat-omap/include/plat/ssi.h
> >  create mode 100644 drivers/hsi/controllers/omap_ssi.c
> >
> > diff --git a/arch/arm/mach-omap2/ssi.c b/arch/arm/mach-omap2/ssi.c
> > new file mode 100644
> > index 0000000..e822a77
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/ssi.c
> > @@ -0,0 +1,134 @@
> > +/*
> > + * linux/arch/arm/mach-omap2/ssi.c
> 
> Minor: Please don't include filenames in the comments.  Files tend to move
> around and these comments don't get updated.

Yep. I'll remove this from all the comments.

> 
> > + * Copyright (C) 2010 Nokia Corporation. All rights reserved.
> > + *
> > + * Contact: Carlos Chinea <carlos.chinea@nokia.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> > + * 02110-1301 USA
> > + */
-- cut --

> > +static struct platform_device ssi_pdev = {
> > +	.name		= "omap_ssi",
> > +	.id		= 0,
> > +	.num_resources	= ARRAY_SIZE(ssi_resources),
> > +	.resource	= ssi_resources,
> > +	.dev		= {
> > +				.platform_data	= &ssi_pdata,
> > +	},
> > +};
> 
> omap_hwmod has all the base address and IRQ data, will construct the
> struct resources and the platform_devices for you.  Please use
> omap_hwmod + omap_device for this part of the code.
> 

Yes, it  is already in my TODO list ;)

Thanks,
Carlos


