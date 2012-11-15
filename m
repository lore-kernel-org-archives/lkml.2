Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767749Ab2KONOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:14:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46197 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767729Ab2KONOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:14:17 -0500
Subject: Re: [PATCH v5 4/4] misc: sram: add support for configurable
 allocation order
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20121114191551.5E8673E0B7C@localhost>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
	 <1350570453-24546-5-git-send-email-p.zabel@pengutronix.de>
	 <20121114191551.5E8673E0B7C@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Nov 2012 14:11:35 +0100
Message-ID: <1352985095.2399.184.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 14.11.2012, 19:15 +0000 schrieb Grant Likely:
> On Thu, 18 Oct 2012 16:27:33 +0200, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > From: Matt Porter <mporter@ti.com>
> > 
> > Adds support for setting the genalloc pool's minimum allocation
> > order via DT or platform data. The allocation order is optional
> > for both the DT property and platform data case. If it is not
> > present then the order defaults to PAGE_SHIFT to preserve the
> > current behavior.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/devicetree/bindings/misc/sram.txt |   12 ++++++++++-
> >  drivers/misc/sram.c                             |   14 ++++++++++++-
> >  include/linux/platform_data/sram.h              |   25 +++++++++++++++++++++++
> >  3 files changed, 49 insertions(+), 2 deletions(-)
> >  create mode 100644 include/linux/platform_data/sram.h
> > 
> > diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> > index b64136c..b1705ec 100644
> > --- a/Documentation/devicetree/bindings/misc/sram.txt
> > +++ b/Documentation/devicetree/bindings/misc/sram.txt
> > @@ -8,10 +8,20 @@ Required properties:
> >  
> >  - reg : SRAM iomem address range
> >  
> > -Example:
> > +Optional properties:
> > +
> > +- alloc-order : Minimum allocation order for the SRAM pool
> 
> Looks okay, but I think the property name is confusing. I for one had
> no idea what 'order' would be and why it was important. I had to read
> the code to figure it out.
> 
> It does raise the question though of what is this binding actually
> for? Does it reflect a limitation of the SRAM? or of the hardware using
> the SRAM? Or is it an optimization? How do you expect to use it?

If I am not mistaken, it is about the expected use case. A driver
allocating many small buffers would quickly fill small SRAMs if the
allocations were of PAGE_SIZE granularity.

I wonder if a common allocation size (say, 512 bytes instead of
PAGE_SIZE) can be found that every prospective user could be reasonably
happy with?

> Assuming it is appropriate to put into the device tree, I'd suggest a
> different name. Instead of 'order', how about 'sram-alloc-align' (in
> address bits) or 'sram-alloc-min-size' (in bytes).

A size in bytes would be the most obvious to me, although that allows to
enter values that are not a power of two.

regards
Philipp


