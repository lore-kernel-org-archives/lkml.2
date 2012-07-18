Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2GRK3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:29:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62319 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2GRK3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:29:30 -0400
Message-ID: <50069006.8050301@linaro.org>
Date: Wed, 18 Jul 2012 11:29:26 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Guo <shawn.guo@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Deepak Saxena <dsaxena@linaro.org>, linux-next@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
References: <5003FB7C.4030509@linaro.org> <20120717130650.GB27595@sirena.org.uk> <500568D9.10805@linaro.org> <20120717133550.GC4477@opensource.wolfsonmicro.com> <50057058.2060002@linaro.org> <20120717142222.GE4477@opensource.wolfsonmicro.com> <50057C1A.80606@linaro.org> <20120717152001.GF4477@opensource.wolfsonmicro.com> <20120718053341.GA4009@S2100-06.ap.freescale.net> <20120718095937.GB22739@opensource.wolfsonmicro.com>
In-Reply-To: <20120718095937.GB22739@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/12 10:59, Mark Brown wrote:
> On Wed, Jul 18, 2012 at 01:33:42PM +0800, Shawn Guo wrote:
>
>> I have an IP block getting different FIFO size on different IMX SoCs.
>> We could introduce a new compatible string for driver to figure it out,
>> but I think the simpler way is just have the data encoded in device
>> tree.  In any case DT is not completely limited in encoding board
>> specific data.  Today, we have IO region and interrupt number of
>> hardware blocks encoded in DT, and to me, FIFO size could just be
>> another aspect of hardware block we could choose to encode in DT.
>
> So, this is part of the problem with encoding the description of the SoC
> into the DT - we're not doing a good job of splitting out the silicon
> description from the board specific description which is not a triumph
> for maintainability since it means that we end up needing to modify the
> DT for every board using the silicon if we want to use the new feature
> (assuming people maintain binary compatibility with old DTs, which we
> don't do a good job at either even for established DT architectures).
>
> It's not the using device tree bit that creates concern for me here,
> it's the fact that the board and silicon aren't being separated.

What's the difference?

The Device Tree describes the hardware (hardware == silicon + 
peripherals). So different platforms are different pieces of hardware. 
Everything the driver can't figure itself out from the silicon itself 
needs to be described in the DT.

We can describe the relationship with a hierarchical layout of the dts 
and dtsi files. So for my recent venture we have:

> +- db8500.dtsi       // silicon
> \	
>  +-- snowball.dts    // board

We also have plans to split it up further:

>           db8xx0.dtsi               // shared silicon
>       _________/\_________
>      /                    \
> db8500.dtsi          db8540.dtsi    // differing silicon
> \                    \
>  +-- snowball.dts     +-- new_board.dts // board

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


