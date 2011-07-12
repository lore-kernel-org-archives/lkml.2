Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1GLQA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:00:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1GLQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:00:56 -0400
Subject: Re: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
 plan
From: Vinod Koul <vkoul@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: vinod.koul@intel.com, "Raju, Sundaram" <sundaram@ti.com>,
        Dan <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110708100410.GA4957@n2100.arm.linux.org.uk>
References: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
	 <20110708100410.GA4957@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Tue, 12 Jul 2011 21:30:18 +0530
Message-ID: <1310486418.14637.1.camel@psiaudioba-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 11:04 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 08, 2011 at 01:52:17PM +0530, Raju, Sundaram wrote:
> > I am planning to move TI SDMA driver in OMAP tree
> > into the dmaengine framework.
> > 
> > The first immediate issue of concern I noticed is the
> > huge number of client drivers that use the existing SDMA driver.
> > More than 15 client drivers are using the current SDMA driver.
> > 
> > Moving the SDMA driver along with all of these client drivers at a
> > single stretch seems a humungous task. 
> > I noticed a model in the existing DMA drivers in dmaengine
> > framework that will over come this issue. 
> 
> It _is_ sane to build a dmaengine driver on top of the existing SoC
> private API, then convert the drivers to DMA engine, and then cleanup
> the resulting DMA engine driver.
> 
> What we must make sure though is that the DMA engine slave API (which
> isn't well documented) is correctly implemented before drivers are
> converted over to use the DMA engine support code, otherwise we may
> end up with lots of drivers that require re-fixing several times over.
Russel,

Remember we have addressed the documentation part, is there something
else you feel is still missing?

-- 
~Vinod Koul
Intel Corp.

