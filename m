Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0LHKd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:33:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57017 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0LHKd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:33:56 -0500
Date: Wed, 8 Dec 2010 11:33:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v8
Message-ID: <20101208103355.GK18244@pengutronix.de>
References: <1291774094.269634.503532219345.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291774094.269634.503532219345.0.gpush@pororo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeremy,

On Wed, Dec 08, 2010 at 10:08:14AM +0800, Jeremy Kerr wrote:
> [apologies for the resend: missed this series description]
> 
> Hi all,
> 
> These patches are an attempt to allow platforms to share clock code. At
> present, the definitions of 'struct clk' are local to platform code,
> which makes allocating and initialising cross-platform clock sources
> difficult, and makes it impossible to compile a single image containing
> support for two ARM platforms with different struct clks.
> 
> The two patches are for the architecture-independent kernel code,
> introducing the common clk infrastructure. The changelog for the first
> patch includes details about the new clock definitions.
> 
> As requested by rmk, I've put together a small series of patches
> illustrating the usage of the common struct clock on the ARM imx51
> platform. These are available in my git tree:
> 
>  git://kernel.ubuntu.com/jk/dt/linux-2.6
> 
> in the clk-common-mx51 branch (clk-common..clk-common-mx51). There is
I would have expected that clk-common is an ancestor of clk-common-mx51.
Currently it bases on v7(?) that doesn't have the spinlock.

BTW, I took a quick look over the patches in clk-common-mx51 and I think
arch/arm/plat-mxc/include/mach/clock.h doesn't compile without
CONFIG_USE_COMMON_STRUCT_CLK (because then there is no struct clk_mxc),
so either you need more magic or just remove the #ifndef
CONFIG_USE_COMMON_STRUCT_CLK.

> also a port  for versatile (clk-common-versatile) in this tree too.
> 
> The approach I've taken with the imx51 port is to temporarly duplicate
> the platform-common clock code (ie, for all mxc-based boards) to enable
> usage of the common struct clk on one machine (imx51), while leaving the
> others as-is. For a proper platform-wide usage of the common struct clk,
> we'd be better off doing the whole platform at once. However, mx51 is
> the only mxc-based HW I have, hence the duplicated example port.
> 
> In the example port, the first change simply converts the mxc's struct
> clk to a struct clk_mxc, using the new API.  The subsequent patches move
> certain clocks to more specific data structures (eg clk_fixed and
> clk_pll) where possible.
> 
> Ben Herrenschmidt is looking at using common struct clk code for powerpc
> too, hence the kernel-wide approach.
> 
> Many thanks to the following for their input:
>  * Ben Dooks <ben-linux@fluff.org>
>  * Baruch Siach <baruch@tkos.co.il>
>  * Russell King <linux@arm.linux.org.uk>
>  * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>  * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
>  * Vincent Guittot <vincent.guittot@linaro.org>
> 
> Russell - now that we've had a few platforms ported to the common clk
> infrastructure, I believe it's ready to merge. If so, do you want this
> in the patch tracker? Otherwise, let me know what needs changing.
> 
> Cheers,

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
