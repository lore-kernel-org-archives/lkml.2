Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1F2PXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:23:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1F2PW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:22:59 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=XYJHFtupD_QA:10 a=BFp1IBu1DmUA:10 a=3jLnhWJ0iCQA:10 a=kj9zAlcOel0A:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:17 a=Ob1vfUIDPTwUVTM7KoQA:9 a=CjuIK1q_8ugA:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.113.120.88
Date: Wed, 29 Jun 2011 10:22:54 -0500
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, Rupjyoti Sarmah <rsarmah@amcc.com>,
        rsarmah@apm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4]PPC4xx: Adding PCI(E) MSI support
Message-ID: <20110629152254.GB29257@crust.elkhashab.com>
References: <201103300910.p2U9AO8t024353@amcc.com>
 <1306387484.7481.453.camel@pasglop>
 <20110628223131.GA10267@crust.elkhashab.com>
 <1309302928.32158.470.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309302928.32158.470.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (crust.elkhashab.com [127.0.0.1]); Wed, 29 Jun 2011 10:22:55 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 09:15:28AM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-28 at 17:31 -0500, Ayman El-Khashab wrote:
> > > > +static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
> > > > +                            struct resource res, struct
> > ppc4xx_msi *msi)
> > > > +{
> > > > +
> > 
> > <snip>
> > 
> > > > +
> > > > +   msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
> > > > +   if (msi->msi_dev)
> > > > +           return -ENODEV;
> > 
> > This does not look correct. I guess it should probably read 
> > 
> > if (!msi->msi_dev) .....
> 
> Indeed, that looks bogus. Rupjyoti, please test and send fixes if
> necessary, obviously this code has not been tested.
> 
> This is not part of the bits I fixed up so I looks to me like the
> original patch was wrong (and thus obviously untested !!!)
> 

Looking back through the mailing list, there have been
various incarnations of this patch to add MSI support to the
44x.  Every one that I looked at had this same line of code
in it so I am not sure they worked.  In any case I am trying
to make it work on my system (which is how I found the bug).
When I enable the "sdr-base" line in the MSI section of my
dts, it just reboots continuosly right after "Loading Device
Tree ....".  I tried renaming it to "msi-sdr-base" just in
case there was a conflict (since it is reading through the
entire tree) but that did not help.  If I understand
correctly, the ppc4xx_msi_probe function must be executing
very early since I suspect something in setup_pcieh_hw is 
what causes it to fail.  

ayman
