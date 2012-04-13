Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2DMPLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:11:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2DMPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:11:41 -0400
Date: Fri, 13 Apr 2012 17:11:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Alex Gershgorin <alexg@meprolight.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: i.mx35 increase dma consistent region size
In-Reply-To: <20120413144029.GP3852@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1204131710260.21260@axis700.grange>
References: <1334167274-29524-1-git-send-email-alexg@meprolight.com>
 <20120413144029.GP3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:O57kQIssQFyxOsTiBf7qM4mZDlA/StxFVyWkWwVc50A
 XxyeIEGcqqYShnu80gZTLcBWjCEHcHzwcPhJyvfiNoO5pNB9qz
 rE2cWOlKieLEXGTiY8pwyLTIG5IjPLP9lVuCeaF5O7kHJshu6V
 NdHDJP51YFIhMW2kX1TrHkKv6dWtVyVYz2yI33NimmPHYzIjuW
 1GBFjB1ppGTsIe7tocTSY5SIxo//akEY4V93z8WaBzUMWcF62B
 L2oJB8AE6ebyOSlpqUen80aMBgZoaGYwq/qBnpDQRiWpUaflNr
 4oVXoy144vZ1OEC4WzoVxeiyAqDFheeMT9AMfLJps6hUaC44y0
 BZeoOv/Vce0nARHcFWSiom6/B+jIe7+YX76eRuzrJxHwdtFiiz
 xpF1tWMOBkdsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Sascha Hauer wrote:

> On Wed, Apr 11, 2012 at 09:01:14PM +0300, Alex Gershgorin wrote:
> > The default size of the consistent DMA region is 2MB
> > without this patch, attempt to allocate more than 2MB
> > is causing allocation failure
> > 
> > Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> > ---
> >  arch/arm/mach-imx/mm-imx3.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
> > index 7412738..a2c0c7d 100644
> > --- a/arch/arm/mach-imx/mm-imx3.c
> > +++ b/arch/arm/mach-imx/mm-imx3.c
> > @@ -201,6 +201,7 @@ static struct map_desc mx35_io_desc[] __initdata = {
> >  void __init mx35_map_io(void)
> >  {
> >  	iotable_init(mx35_io_desc, ARRAY_SIZE(mx35_io_desc));
> > +	init_consistent_dma_size(SZ_8M);
> 
> I don't know what to think about this. You probably have a board with
> camera support and thus need bigger buffers, right? Nevertheless this
> patch affects all i.MX35 users, even the ones without camera support.
> 
> Another possibility would be to make this board specific.

Isn't this what other (including i.MX3*) boards use arm_memblock_steal() 
for?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
