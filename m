Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2LDQTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:19:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2LDQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:19:22 -0500
Date: Tue, 4 Dec 2012 08:19:18 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v7 0/4] Add generic driver for on-chip SRAM
Message-ID: <20121204161918.GC17860@kroah.com>
References: <1353680655-21624-1-git-send-email-p.zabel@pengutronix.de>
 <1354611218.3410.11.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354611218.3410.11.camel@pizza.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 09:53:38AM +0100, Philipp Zabel wrote:
> Hi,
> 
> On Fri, 2012-11-23 at 15:24 +0100, Philipp Zabel wrote:
> > These patches add support to configure on-chip SRAM via device-tree
> > node or platform data and to obtain the resulting genalloc pool from
> > the physical address or a phandle pointing at the device tree node.
> > This allows drivers to allocate SRAM with the genalloc API without
> > hard-coding the genalloc pool pointer.
> 
> are there any further comments on this series?
> 
> > The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
> > and changed to use the simple generic SRAM driver:
> > 
> >                 ocram: ocram@00900000 {
> >                         compatible = "fsl,imx-ocram", "sram";
> >                         reg = <0x00900000 0x3f000>;
> >                 };
> > 
> > A driver that needs to allocate SRAM buffers, like the video processing
> > unit on i.MX53, can retrieve the genalloc pool from a phandle in the
> > device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:
> > 
> >                 vpu@63ff4000 {
> >                         /* ... */
> >                         iram = <&ocram>;
> >                 };
> > 
> > The allocation granularity is hard-coded to 32 bytes for now,
> > until a way to configure it can be agreed upon. There is overhead
> > for bigger SRAMs, where only a much coarser allocation granularity
> > is needed: At 32 bytes minimum allocation size, a 256 KiB SRAM
> > needs a 1 KiB bitmap to track allocations.
> > 
> > Once everybody is ok with it, could the first two patches be merged
> > through the char-misc tree? I'll resend the i.MX and coda patches to
> > the respective lists afterwards.
> 
> Arnd, Greg, would you take the first patch "genalloc: add a global pool
> list, allow to find pools by phys address" into the char-misc tree if
> there are no vetoes? Or should I try and get it merged separately,
> first?

It's too late for anything new for 3.8, so how about resending this all
after 3.8-rc1 is out and we can take it from there?

thanks,

greg k-h
