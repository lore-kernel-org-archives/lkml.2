Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2GTGkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:40:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:7700 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2GTGkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170700361"
Subject: Re: [PATCH] dma: tegra: enable/disable dma clock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <5008F4D8.9070108@nvidia.com>
References: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com>
	 <1342764141.1726.199.camel@vkoul-udesk3>  <5008F4D8.9070108@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 12:10:45 +0530
Message-ID: <1342766445.1726.246.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 11:34 +0530, Laxman Dewangan wrote:
> On Friday 20 July 2012 11:32 AM, Vinod Koul wrote:
> > On Wed, 2012-07-18 at 14:26 +0530, Laxman Dewangan wrote:
> >> Enable the DMA clock when registering DMA driver and
> >> disable clock when removing the DMA driver.
> >>
> >> The failure was observed on Tegra20 based system by
> >> Stephen Warren. However, it is working fine on tegra30
> >> based system and probably becasue uboot enable the clock
> >> on Tegra30.
> > Don't know much about the clock subsystem, but shouldn't the clocks be
> > enabled runtime..... when you actually start using the controller??
> 
> Yes, this is the plan and I am going to implement dynamic clock 
> management but it will take some time to complete and have testing 
> throughly. some of the issue which I am seeing and analyzing on this 
> approach is that
>   - clock disable can be called from isr context or not?
>   - how much complexity will be added in dma driver to implement this?
>   - What power benefit we will get on this.
>   - Is there any user which generally use dma and always keep dma on 
> requested state like UART RX always ready etc.
> 
> So keeping that in mind, it will take some time to complete this and 
> meanwhile, I want to make it work for Tegra20 based system which is not 
> working on current driver.
> and hence this is the change.
for a start you can move these to .alloc_chan_resources
and .free_chan_resources while doing a  refcount.
Further optimization can be done by moving this to tx_submit and
tasklet.

-- 
~Vinod

