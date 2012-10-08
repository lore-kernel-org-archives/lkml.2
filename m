Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2JHKRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:17:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:40068 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2JHKRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,551,1344236400"; 
   d="scan'208";a="231191527"
Message-ID: <1349691428.10584.95.camel@smile>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Mon, 08 Oct 2012 13:17:08 +0300
In-Reply-To: <CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348735450.1648.5.camel@vkoul-udesk3> <1348739022.13371.157.camel@smile>
	 <1348740071.1648.25.camel@vkoul-udesk3>
	 <CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 15:41 +0530, viresh kumar wrote: 
> On Thu, Sep 27, 2012 at 3:31 PM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> > Let me try again.
> >
> > what does it take to do platform and PCI driver for this:
> > 1. make dma h/w access (read/write) platform independent. which you have
> > already done
> > 2. Device registration: Create two probes, or use common probe.
> > You smartly chose the second one BUT by creating another device.
> > If you look closely at the probe then I would say it would be easy to
> > create library for probe which can be used across both pci and platform
> > driver probes. The probe library which initializes driver and registers
> > with dmaengine needs device struct and resources can be provided by each
> > probe.
> 
> Or in other words... create three files
> - dw_dmac.c
> - dw_dmac-pltfm.c
> - dw_dmac-pci.c...
> 
> Don't do anything specific to platform or pci in dw_dmac.c...
> Keep pltfm and pci files to smallest possible size, and keep as much of
> common part in dmac.c...
> 
> Similar is done in drivers/mmc/host/sdhci*...

This approach has the significant differences to proposed before.

First of all it will export IP-block relevant functions to the kernel
namespace. I think it is not a good idea to pollute kernel more.
Moreover the API dependencies disallow transparent build and usage of
the drivers. For example, you can't built-in platform driver and leave
core part as a module. And there is at least one device, Intel Medfield,
where DMA controller is exposed as PCI device on fake PCI bus. In that
case the initialization sequence matters and the easier way is to
provide independent drivers for platform device. 


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
