Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1E2V6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:58:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41879 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1E2V6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:58:21 -0400
Date: Sun, 29 May 2011 22:58:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
Message-ID: <20110529215805.GB5576@n2100.arm.linux.org.uk>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <20110528234614.GV24876@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105281913490.15709@chino.kir.corp.google.com> <20110529072516.GW24876@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105291417090.9658@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105291417090.9658@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 02:19:40PM -0700, David Rientjes wrote:
> On Sun, 29 May 2011, Russell King - ARM Linux wrote:
> 
> > > arm, pxa2xx: enable DMA support for pxa2xx IRDA interface
> > > 
> > > The pxa2xx-ir driver allocates with GFP_DMA, so it must always have 
> > > ZONE_DMA.
> > 
> > Wrong way.  If there's no restrictions, drivers shouldn't be using
> > GFP_DMA.  For the majority of SoCs, that's the case.
> > 
> 
> That's great, but before you can actually determine what requires DMA for 
> this driver and what doesn't, we need something for this merge window (and 
> backported to -stable) so that users aren't forced to go through and 
> enable CONFIG_ZONE_DMA on their own .config.
> 
> Is there a downside to enabling CONFIG_ZONE_DMA for all configs that 
> compile this driver until a better solution can be found?

We might as well enable CONFIG_ZONE_DMA for everything if that's what
you're proposing, because it's not just this driver which will be affected.
And as soon as we do that, we completely lose the warnings that stuff
needs fixing.

This is not the way to sort this problem out.
