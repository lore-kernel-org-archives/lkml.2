Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1LLWwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:52:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45896 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1LLWwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:52:21 -0500
Message-ID: <4EE6859F.2040807@gmail.com>
Date: Mon, 12 Dec 2011 16:52:15 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: Initial DT clock bindings
References: <1323727236-4811-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1323727236-4811-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 04:00 PM, Grant Likely wrote:
> Hi everyone,
> 
> Here's my second posting of initial device tree bindings for clocks.  I'm
> a lot happier with how this is looking now, and Versatile is pretty much
> entirely converted.  In fact, the realview, integrator and vexpress platforms
> are pretty close now too.  Just for fun I went and converted Highbank also.

Thanks! I'll give it a spin.

> There is still stuff to clean up, and I want to add test cases for the new
> clock framework, but otherwise I think it is pretty complete.  There are
> some changes to the binding documentation that you'll want to pay attention
> to.
> 
> This series is based on v3.2-rc5 plus the of_parse_phandle_args() patches
> that I posted a couple of hours ago.
> 
Where? I'm not seeing them on devicetree-discuss.

Can you publish this series on your git tree?

Rob

> 
>  .../devicetree/bindings/clock/clock-bindings.txt   |  114 +++++++++++
>  .../devicetree/bindings/clock/fixed-clock.txt      |   21 ++
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/highbank.dts                     |   32 +++-
>  arch/arm/boot/dts/testcases/tests-phandle.dtsi     |    2 +
>  arch/arm/boot/dts/versatile-ab.dts                 |   79 ++++++++
>  arch/arm/common/timer-sp.c                         |   72 ++++++-
>  arch/arm/include/asm/hardware/timer-sp.h           |    2 +
>  arch/arm/mach-highbank/clock.c                     |   19 --
>  arch/arm/mach-highbank/core.h                      |    1 -
>  arch/arm/mach-highbank/highbank.c                  |   13 +-
>  arch/arm/mach-highbank/include/mach/clkdev.h       |   11 +
>  arch/arm/mach-integrator/impd1.c                   |   30 +---
>  arch/arm/mach-integrator/include/mach/clkdev.h     |   19 --
>  arch/arm/mach-integrator/integrator_cp.c           |   21 +--
>  arch/arm/mach-realview/core.c                      |   22 +--
>  arch/arm/mach-realview/include/mach/clkdev.h       |   10 -
>  arch/arm/mach-versatile/core.c                     |   61 +------
>  arch/arm/mach-versatile/include/mach/clkdev.h      |   10 -
>  arch/arm/mach-versatile/versatile_dt.c             |   39 ++++-
>  arch/arm/mach-vexpress/include/mach/clkdev.h       |    9 -
>  arch/arm/mach-zynq/include/mach/clkdev.h           |   10 -
>  arch/arm/plat-versatile/clock.c                    |  151 ++++++++++++++
>  arch/arm/plat-versatile/include/plat/clock.h       |   34 ++++
>  drivers/clk/clkdev.c                               |    9 +
>  drivers/of/Kconfig                                 |    6 +
>  drivers/of/Makefile                                |    1 +
>  drivers/of/base.c                                  |   36 ++++
>  drivers/of/clock.c                                 |  208 ++++++++++++++++++++
>  drivers/of/selftest.c                              |   29 +++
>  include/linux/of.h                                 |    3 +
>  include/linux/of_clk.h                             |   41 ++++
>  32 files changed, 893 insertions(+), 223 deletions(-)
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

