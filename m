Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab2CFMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:04:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:8071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759211Ab2CFMEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:04:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125600764"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1203060935460.9300@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
	 <Pine.LNX.4.64.1203021341590.913@axis700.grange>
	 <1331022623.24656.191.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203060935460.9300@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 17:38:59 +0530
Message-ID: <1331035739.24656.201.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 09:53 +0100, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> Thanks for your review.
> 
> On Tue, 6 Mar 2012, Vinod Koul wrote:
> 
> > On Fri, 2012-03-02 at 14:21 +0100, Guennadi Liakhovetski wrote:
> > > Hi Vinod
> > > 
> > > On Wed, 1 Feb 2012, Guennadi Liakhovetski wrote:
> > sorry I thought I had replied, but looks like it got missed!
> > > 
> > > > When performing slame DMA some dmaengine drivers need additional data from
> > typo		  ^^^^^^^^^
> > > > client drivers to find out, whether they can support that specific client
> > > > and to configure the DMA channel for it. This additional data has to be
> > > > supplied by client drivers during channel allocation, i.e., with the
> > > > __dma_request_channel() function. This patch adds a new
> > > > struct dma_slave_desc with some basic data in it, further this struct can
> > > > be embedded in hardware-specific types to supply any auxiliary
> > > > configuration.
> > counter arguing shouldn't the client drivers find out of the channel
> > requested is capable or not, that can be alternate approach as well.
> > That way people implement this in the filer functions and find if this
> > is the channel we need rather than dmac finding out if it can service
> > the client or not.
> 
> How shall clients find this out? This is system- and DMAC-specific, this 
> has nothing to do with the client functionality. The proposed approach is:
> 
> * a client driver (MMC, USB, anything else) is capable to use DMA uses the 
> standard dmaengine API to transfer the data
> 
> * if the platform, where it's running, is supplying any auxiliary data, 
> that it has to pass to the DMAC driver, it can do so, without getting 
> involved in the details, just passing a pointer
> 
> * the most natural location to do this is IMHO when requesting a DMA 
> channel
and in that case why do you need the new parameters to be passed back in
filter function. What is the role of filter in this case ?

> 
> Now, on sh-mobile platforms you can realistically have around 5 DMAC 
> instances with 2 or 6 channels each, of which, say, 3 controllers are 
> suitable for MMC and 2 are not. How shall the filter function find this 
> out? Call some ugly platform callback? Traverse some platform-specific 
> lists? Or use a fixed channel, thus significantly reducing flexibility? 
> Sorry, none of these options seems very attractive to me.
well you can counter argue that dmac does not have this information
either.

Bigger question is who knows about this mapping and how do we
incorporate this mapping into channel allocation
> 
> > Frankly I prefer former model, as that way dmacs will present channel
> > capabilities, and clients can use as they deem fit.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> [snip]



-- 
~Vinod

