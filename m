Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2I0KHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:07:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:12056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2I0KHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="227209839"
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
In-Reply-To: <1348739022.13371.157.camel@smile>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348735450.1648.5.camel@vkoul-udesk3>  <1348739022.13371.157.camel@smile>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:31:11 +0530
Message-ID: <1348740071.1648.25.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 12:43 +0300, Andy Shevchenko wrote:
> On Thu, 2012-09-27 at 14:14 +0530, Vinod Koul wrote: 
> > > +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> > > +				  const struct pci_device_id *id)
> > > +{
> > ...
> > > +
> > > +	pd = platform_device_alloc("dw_dmac", instance);
> > Why can't the core driver library be agnostic. Why do we care if the
> > device is platform, pci or something else. 
> > There is nothing in dma API callbacks which driver implements that
> > warrants it to be some device.
> > 
> > You have already taken care of dma controller accesses be arch
> > independent so I don't see a reason why this should be done?
> I'm afraid I didn't get you comment.
Let me try again.

what does it take to do platform and PCI driver for this:
1. make dma h/w access (read/write) platform independent. which you have
already done
2. Device registration: Create two probes, or use common probe.
You smartly chose the second one BUT by creating another device.
If you look closely at the probe then I would say it would be easy to
create library for probe which can be used across both pci and platform
driver probes. The probe library which initializes driver and registers
with dmaengine needs device struct and resources can be provided by each
probe.

-- 
~Vinod

