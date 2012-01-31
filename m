Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2AaGk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:40:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:49171 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2AaGk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:40:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118405049"
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1201300944360.7932@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
	 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
	 <1327912346.1527.13.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1201300944360.7932@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 12:11:30 +0530
Message-ID: <1327992090.1527.116.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 10:34 +0100, Guennadi Liakhovetski wrote:
> > I don't still comprehend the need for a library on top of dmaengine
> > which gain is just a library between clients and dmacs. Surely we don't
> > want to write another abstraction on top of one provided?
> > 
> > If the question is to handle scatter-gather even if the hardware doesn't
> > have the capability, then why don't add that in dmaengine itself rather
> > than one more layer?
> 
> Well, yes, adding new abstraction layers is always a decision, that has to 
> be well justified. In this case it does at least make the life easier for 
> two sh-mobile drivers: shdma and the new SUDMAC driver.
> 
> However, I did name the library in a generic way without reference to sh, 
> assuming, that it might with time become useful for other architectures 
> too. The reasons why I prefered to keep it as an optional addition to 
> dmaengine core, instead of tightly integrating it with it are, that (1) I 
> did not want to add useless code to drivers, that do not need it, 
So are we sure that only sh-mobile drivers need this capablity?
Btw does you hardware only support single transfers and no sg support,
would this remain the same in future?
> (2) I am 
> not sure if and when this library will become useful for other drivers: 
> apart from sh I am only familiar with one more dmaengine driver: 
> ipu/ipu_idmac.c, and that one supports scatter-gather lists in a limited 
> way and has some further peculiarities, that would likely make it a bad 
> match for the simple DMA library,
typically the dmacs will support this in some form or other, so your
point is valid :)
>  (3) keeping it separate makes its 
> further development easier.
> 
> OTOH, I'm certainly fine with a tighter library integration with the 
> dmaengine core. I think, it still would be better to keep it in a separate 
> file and only build it if needed, right? This woult also simplify code 
> debugging and further development. I can remove the "simple" notation, 
> which does make it look like an additional abstraction layer, and replace 
> it with, say, sgsoft (scatter-gather software implementation)?
that would be more apt :)
>  A more 
> interesting question is what to do with struct dma_simple_dev, struct 
> dma_simple_chan, struct dma_simple_desc, that embed struct dma_device, 
> struct dma_chan and struct dma_async_tx_descriptor respectively. I don't 
> think we want to merge all the additions from those wrapping structs back 
> into their dmaengine counterparts?
Sure they should be kept separate. I like the wrapping, this keeps it
simple.
> 
> How would you like to do this? Don't you think, it would be good to allow 
> both: either implement a dmaengine driver directly, exactly as all drivers 
> are doing now, or use the additional helper library for suitable (simple) 
> hardware types? I see it similar to I2C, where you either implement an I2C 
> driver directly, or you use the bitbanging abstraction for simpler 
> hardware.
I think it would be good to have both, this can be used by folks who
don't have sg support available.

-- 
~Vinod

