Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2KLVWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:22:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41839 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab2KLVWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:22:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <CAPub148Bq=uwTuky25WzXn4yfCukJ+WacxkBvuyV5yTzGasGOQ@mail.gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>
References: <CAPub14-CPS48gQ1h8vvAYBpO_=egjheG_rMoZ894Y4XZ2CinUQ@mail.gmail.com>
 <CAPub148Bq=uwTuky25WzXn4yfCukJ+WacxkBvuyV5yTzGasGOQ@mail.gmail.com>
Message-ID: <20121112212212.20034.78522@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: possibility of parent clock selection through DT
Date: Mon, 12 Nov 2012 13:22:12 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shiraz Hashim (2012-11-06 22:36:10)
> On Wed, Nov 7, 2012 at 11:42 AM, Shiraz Hashim
> <shiraz.linux.kernel@gmail.com> wrote:
> > Hi Mike, Rob,
> >
> > Devices in a SoC can have multiple possible clock sources which is
> > perfectly captured through clk framework.
> >
> > But the device itself may not be aware of the complex hierarchy above it.
> > In this case how do you suggest a board (through DT) should select its
> > preference.
> >
> > Is there some work already going on in this direction ?
> 
> Just to make it clear, I already have referred the clock DT bindings and
> Shawn Guo patch on removing clk look up registration from kernel code.
> 
> Here I am talking about possibility of selecting desired clock hierarchy
> by the boards about which device nodes are not aware.
> 

One way to achieve this is to use clk_set_rate as a way to switch
parents at run-time.  The OMAP CCF code currently does this when
relocking PLLs and makes use of __clk_reparent to update the clock
framework's representation of the hierarchy dynamically.

Maybe something like the following is helpful to you:
http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/dpll3xxx.c;h=f72dedb4eee892ce4cd5bdf22cc8c22510f3d526;hb=clk-omap-3.8#l542

Regards,
Mike

> -- 
> regards
> Shiraz Hashim
