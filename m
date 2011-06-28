Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1F1XP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:15:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:59895 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab1F1XPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:15:54 -0400
Subject: Re: [PATCH v4]PPC4xx: Adding PCI(E) MSI support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linuxppc-dev@ozlabs.org,
        rsarmah@apm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110628223131.GA10267@crust.elkhashab.com>
References: <201103300910.p2U9AO8t024353@amcc.com>
	 <1306387484.7481.453.camel@pasglop>
	 <20110628223131.GA10267@crust.elkhashab.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 09:15:28 +1000
Message-ID: <1309302928.32158.470.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 17:31 -0500, Ayman El-Khashab wrote:
> > > +static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
> > > +                            struct resource res, struct
> ppc4xx_msi *msi)
> > > +{
> > > +
> 
> <snip>
> 
> > > +
> > > +   msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
> > > +   if (msi->msi_dev)
> > > +           return -ENODEV;
> 
> This does not look correct. I guess it should probably read 
> 
> if (!msi->msi_dev) .....

Indeed, that looks bogus. Rupjyoti, please test and send fixes if
necessary, obviously this code has not been tested.

This is not part of the bits I fixed up so I looks to me like the
original patch was wrong (and thus obviously untested !!!)

Cheers,
Ben.


