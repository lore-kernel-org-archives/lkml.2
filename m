Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2CGGXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:23:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:23637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2CGGXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:23:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125991936"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, rmk <rmk@arm.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.1203061339330.9300@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
	 <Pine.LNX.4.64.1203021341590.913@axis700.grange>
	 <1331022623.24656.191.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203060935460.9300@axis700.grange>
	 <1331035739.24656.201.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203061339330.9300@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 11:58:07 +0530
Message-ID: <1331101687.24656.319.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 14:03 +0100, Guennadi Liakhovetski wrote:
<adding few folks to thread, who i may be intrested in this discussion>
> But the DMAC is certainly a better match for making channel-selection 
> decisions.
I am not sure about that as well...
> 
> > Bigger question is who knows about this mapping and how do we
> > incorporate this mapping into channel allocation
> 
> The platform does. And this knowledge has to be passed to the relevant 
> driver. But I think it's the DMAC driver, that is relevant, not the client 
> driver. The platform would supply information like
> 
> DMAC #1
> 	channel #1
> 		(can be used for) device #1
> 		device #2
> 		...
> 	channel #2
> 	...
> ...
right :-)
and we need to ensure that somehow this information is presented to
dmaengine and dmaengine uses this information to filter the channel
requests. In past we had good discussion [1], [2], [3] on this topic but
unfortunately nothing came out of it.

I like the approach outlined by Linus W [1], where we can get the
information from platform (DT, FW,....) and its presented to dmaengine.

I think we need to solve this _now_. There are two aspects
a) to ensure dmaengine understand channel-client mapping. For this we
can start with idea in [1] and see if this suits everyones needs
b) how to ensure the platform gives this information in variety of arch
we have (arm, x86, sh-....)

Thoughts...?
> And I don't think, it would be reasonable to let every slave driver use 
> this information. These lists can also be optimised for specific 
> platforms. E.g., on some sh-mobile SoCs you have two DMAC types. One of 
> them can serve devices from list A on any channel, the other one - from 
> list B. So, all you have to do, is to reference either A or B from your 
> DMAC platform data. Whereas doing a reverse mapping: for each (potential) 
> DMA user reference a list of channels, that it can use - would be really 
> clumsy.
> 
[1]:
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-August/060717.html
[2]:
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059212.html
[3]:
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059217.html


-- 
~Vinod

