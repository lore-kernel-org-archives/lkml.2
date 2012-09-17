Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2IQPZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:25:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32941 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab2IQPZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:25:19 -0400
X-Sasl-enc: Y3a+qs1M+u5wkD44qmwGOd+A6A8xmLlNc961pGqQ6QvW 1347895518
Date: Mon, 17 Sep 2012 08:25:16 -0700
From: Greg KH <greg@kroah.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: konrad.wilk@oracle.com, joerg.roedel@amd.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, devel@linuxdriverproject.org,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120917152516.GB13835@kroah.com>
References: <1347843171.4370.13.camel@lorien2>
 <20120917020741.GA3841@kroah.com>
 <1347893158.3227.15.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347893158.3227.15.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 08:45:58AM -0600, Shuah Khan wrote:
> On Sun, 2012-09-16 at 19:07 -0700, Greg KH wrote:
> > On Sun, Sep 16, 2012 at 06:52:51PM -0600, Shuah Khan wrote:
> > > +void debug_dma_dump_map_errors(struct device *dev, int all)
> > > +{
> > > +	if (all) {
> > > +		dev_info(dev,
> > > +			 "DMA-API: DMA map error summary:\n"
> > > +			 "DMA map errors returned = %d\n"
> > > +			 "DMA map errors not checked = %d\n"
> > > +			 "DMA unmap errors = %d\n"
> > > +			 "SWIOTLB overflow triggers = %d\n",
> > > +			 dev->dma_map_errors,
> > > +			 dev->dma_map_errors_not_checked,
> > > +			 dev->dma_unmap_errors,
> > > +			 dev->iotlb_overflow_cnt);
> > > +		return;
> > > +	}
> > > +
> > > +	if (dev->dma_map_errors_not_checked) {
> > > +		dev_err(dev,
> > > +			"DMA-API: Driver failed to check\n"
> > > +			"%d out of a total of %d DMA map errors returned\n"
> > > +			"by DMA mapping interfaces\n",
> > > +			dev->dma_map_errors_not_checked,
> > > +			dev->dma_map_errors);
> > > +	}
> > > +
> > > +	if (dev->dma_unmap_errors) {
> > > +		dev_err(dev,
> > > +			"DMA-API: Driver tried to free invalid\n"
> > > +			"DMA addresses %d times\n",
> > > +			dev->dma_unmap_errors);
> > > +	}
> > > +
> > > +	if (dev->iotlb_overflow_cnt) {
> > > +		dev_err(dev,
> > > +			"DMA-API: SWIOTLB overflow buffer triggered %d times\n",
> > > +			dev->iotlb_overflow_cnt);
> > > +	}
> > > +}
> > > +EXPORT_SYMBOL(debug_dma_dump_map_errors);
> > 
> > Don't use syslog for stuff like this, that's not good.  Why not use
> > debugfs?
> 
> This debug interface debug_dma_dump_map_errors() is enabled only when
> CONFIG_DMA_API_DEBUG is enabled, however I agree that debugfs is a
> better choice than logging to syslog. I created debugfs interfaces for
> these error counts at system level. Are recommending the same approach
> for per device counts as well? 

No, I have no idea about that (but hint, I really don't like adding
stuff to struct device for something like this, especially with a #ifdef
in it, that seems really wrong here.)  All I wanted to point out was
that do not use the syslog for this, use debugfs instead.

greg k-h
