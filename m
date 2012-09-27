Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2I0IuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:50:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:19982 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2I0IuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="214218220"
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
In-Reply-To: <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 14:14:10 +0530
Message-ID: <1348735450.1648.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 10:31 +0300, Andy Shevchenko wrote:
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/dw_dmac.h>
> +
> +static struct dw_dma_platform_data pdata = {
> +	.is_private = 1,
> +	.chan_allocation_order = CHAN_ALLOCATION_ASCENDING,
> +	.chan_priority = CHAN_PRIORITY_ASCENDING,
> +};
pdata could use a prefix/suffix

> +
> +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> +				  const struct pci_device_id *id)
> +{
...
> +
> +	pd = platform_device_alloc("dw_dmac", instance);
Why can't the core driver library be agnostic. Why do we care if the
device is platform, pci or something else. 
There is nothing in dma API callbacks which driver implements that
warrants it to be some device.

You have already taken care of dma controller accesses be arch
independent so I don't see a reason why this should be done?
> +	if (!pd) {
> +		dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
> +		ret = -ENOMEM;
> +		goto err0;
> +	}

-- 
~Vinod

