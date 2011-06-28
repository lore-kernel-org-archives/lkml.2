Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1F1Wbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1F1Wbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:31:37 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=XYJHFtupD_QA:10 a=BFp1IBu1DmUA:10 a=3jLnhWJ0iCQA:10 a=kj9zAlcOel0A:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:17 a=_XEO3y2Ik1CnJoPwEJIA:9 a=CjuIK1q_8ugA:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.113.120.88
Date: Tue, 28 Jun 2011 17:31:31 -0500
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linuxppc-dev@ozlabs.org,
        rsarmah@apm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4]PPC4xx: Adding PCI(E) MSI support
Message-ID: <20110628223131.GA10267@crust.elkhashab.com>
References: <201103300910.p2U9AO8t024353@amcc.com>
 <1306387484.7481.453.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306387484.7481.453.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (crust.elkhashab.com [127.0.0.1]); Tue, 28 Jun 2011 17:31:32 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 03:24:44PM +1000, Benjamin Herrenschmidt wrote:
> 
> Please check the result and send any "fixup" patch that might be
> necessary.
> 
> > +static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
> > +				 struct resource res, struct ppc4xx_msi *msi)
> > +{
> > +

<snip>

> > +
> > +	msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
> > +	if (msi->msi_dev)
> > +		return -ENODEV;

This does not look correct. I guess it should probably read 

if (!msi->msi_dev) .....

Ayman
