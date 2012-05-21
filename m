Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2EUIrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:47:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5483 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2EUIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:47:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 21 May 2012 01:47:15 -0700
Date: Mon, 21 May 2012 11:46:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "Turquette, Mike" <mturquette@ti.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
Message-ID: <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2>
 <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2>
 <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On OMAP I think the only "gotcha" is setting up the timer.  One
> solution is to open code the register reads and the rate calculation
> in the timer code.  That is ugly... but it works.
> 
> > Which advantages do you see in dynamically allocating all this?
> >
> 
> There are many but I'll name a couple.  The most significant point is
> that we can avoid exposing the definition of struct clk if we
> dynamically allocate stuff.  One can use struct clk_hw_init to
> statically initialize data, or instead rely on direct calls to
> clk_register with a bunch of parameters.
> 

Which means if you make a mistake in specifying parents for example, it will
only fail at runtime, possibly before any console is active. With static
initialization, this will fail at compiletime. Much easier to debug.

> Another point is that copying the data at registration-time makes
> __initdata possible.  I haven't done the math yet to see if this
> really makes a difference.  However if we start doing single zImage's
> with multiple different ARM SoCs then this could recover some pages.
> 

On the other hand most clock structures are small, so there will be internal
fragmentation. Also the arrays of parent clock pointers can be shared between
different clocks. We have about 70 muxes in Tegra30 and 12 different parent
arrays.

Cheers,

Peter.
