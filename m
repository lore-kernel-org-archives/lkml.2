Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2IQOxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:53:40 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:34657 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2IQOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:53:38 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:53:38 EDT
Message-ID: <1347893158.3227.15.camel@lorien2>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Greg KH <greg@kroah.com>
Cc: konrad.wilk@oracle.com, joerg.roedel@amd.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, devel@linuxdriverproject.org,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, shuahkhan@gmail.com
Date: Mon, 17 Sep 2012 08:45:58 -0600
In-Reply-To: <20120917020741.GA3841@kroah.com>
References: <1347843171.4370.13.camel@lorien2>
	 <20120917020741.GA3841@kroah.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-16 at 19:07 -0700, Greg KH wrote:
> On Sun, Sep 16, 2012 at 06:52:51PM -0600, Shuah Khan wrote:
> > +void debug_dma_dump_map_errors(struct device *dev, int all)
> > +{
> > +	if (all) {
> > +		dev_info(dev,
> > +			 "DMA-API: DMA map error summary:\n"
> > +			 "DMA map errors returned = %d\n"
> > +			 "DMA map errors not checked = %d\n"
> > +			 "DMA unmap errors = %d\n"
> > +			 "SWIOTLB overflow triggers = %d\n",
> > +			 dev->dma_map_errors,
> > +			 dev->dma_map_errors_not_checked,
> > +			 dev->dma_unmap_errors,
> > +			 dev->iotlb_overflow_cnt);
> > +		return;
> > +	}
> > +
> > +	if (dev->dma_map_errors_not_checked) {
> > +		dev_err(dev,
> > +			"DMA-API: Driver failed to check\n"
> > +			"%d out of a total of %d DMA map errors returned\n"
> > +			"by DMA mapping interfaces\n",
> > +			dev->dma_map_errors_not_checked,
> > +			dev->dma_map_errors);
> > +	}
> > +
> > +	if (dev->dma_unmap_errors) {
> > +		dev_err(dev,
> > +			"DMA-API: Driver tried to free invalid\n"
> > +			"DMA addresses %d times\n",
> > +			dev->dma_unmap_errors);
> > +	}
> > +
> > +	if (dev->iotlb_overflow_cnt) {
> > +		dev_err(dev,
> > +			"DMA-API: SWIOTLB overflow buffer triggered %d times\n",
> > +			dev->iotlb_overflow_cnt);
> > +	}
> > +}
> > +EXPORT_SYMBOL(debug_dma_dump_map_errors);
> 
> Don't use syslog for stuff like this, that's not good.  Why not use
> debugfs?

This debug interface debug_dma_dump_map_errors() is enabled only when
CONFIG_DMA_API_DEBUG is enabled, however I agree that debugfs is a
better choice than logging to syslog. I created debugfs interfaces for
these error counts at system level. Are recommending the same approach
for per device counts as well? 

-- Shuah

