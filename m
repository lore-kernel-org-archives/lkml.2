Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2IQCQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 22:16:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41433 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab2IQCQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 22:16:20 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Sep 2012 22:16:20 EDT
X-Sasl-enc: VFYdgN3kB+i+8bhmtvSS4m0SbuQHLX5gQBA37jYRQwM8 1347847663
Date: Sun, 16 Sep 2012 19:07:41 -0700
From: Greg KH <greg@kroah.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: konrad.wilk@oracle.com, joerg.roedel@amd.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, shuahkhan@gmail.com,
        devel@linuxdriverproject.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120917020741.GA3841@kroah.com>
References: <1347843171.4370.13.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347843171.4370.13.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 06:52:51PM -0600, Shuah Khan wrote:
> +void debug_dma_dump_map_errors(struct device *dev, int all)
> +{
> +	if (all) {
> +		dev_info(dev,
> +			 "DMA-API: DMA map error summary:\n"
> +			 "DMA map errors returned = %d\n"
> +			 "DMA map errors not checked = %d\n"
> +			 "DMA unmap errors = %d\n"
> +			 "SWIOTLB overflow triggers = %d\n",
> +			 dev->dma_map_errors,
> +			 dev->dma_map_errors_not_checked,
> +			 dev->dma_unmap_errors,
> +			 dev->iotlb_overflow_cnt);
> +		return;
> +	}
> +
> +	if (dev->dma_map_errors_not_checked) {
> +		dev_err(dev,
> +			"DMA-API: Driver failed to check\n"
> +			"%d out of a total of %d DMA map errors returned\n"
> +			"by DMA mapping interfaces\n",
> +			dev->dma_map_errors_not_checked,
> +			dev->dma_map_errors);
> +	}
> +
> +	if (dev->dma_unmap_errors) {
> +		dev_err(dev,
> +			"DMA-API: Driver tried to free invalid\n"
> +			"DMA addresses %d times\n",
> +			dev->dma_unmap_errors);
> +	}
> +
> +	if (dev->iotlb_overflow_cnt) {
> +		dev_err(dev,
> +			"DMA-API: SWIOTLB overflow buffer triggered %d times\n",
> +			dev->iotlb_overflow_cnt);
> +	}
> +}
> +EXPORT_SYMBOL(debug_dma_dump_map_errors);

Don't use syslog for stuff like this, that's not good.  Why not use
debugfs?

greg k-h
