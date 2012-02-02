Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2BBOb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:31:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48752 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2BBObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:31:24 -0500
Date: Thu, 2 Feb 2012 22:43:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
Message-ID: <20120202144344.GI9773@S2101-09.ap.freescale.net>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
 <CACRpkda+KCutSFgPwH2Xvd14h0OCrArFGXAidp3n_ZgG28KB5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda+KCutSFgPwH2Xvd14h0OCrArFGXAidp3n_ZgG28KB5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:26:54PM +0100, Linus Walleij wrote:
> On Wed, Feb 1, 2012 at 10:04 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This adds a driver for the Tegra pinmux, and required parameterization
> > data for Tegra20 and Tegra30.
> 
> OK so I've applied this monster patch and the three others,
> 
> the diffstat looks like so:
> 
> git diff --stat v3.3-rc2..HEAD
>  arch/arm/mach-tegra/Kconfig                       |    4 +
>  arch/arm/mach-tegra/Makefile                      |    3 -
>  arch/arm/mach-tegra/board-harmony-pinmux.c        |  362 ++-
>  arch/arm/mach-tegra/board-paz00-pinmux.c          |  362 ++-
>  arch/arm/mach-tegra/board-pinmux.c                |   62 +-
>  arch/arm/mach-tegra/board-pinmux.h                |   39 +-
>  arch/arm/mach-tegra/board-seaboard-pinmux.c       |  442 ++-
>  arch/arm/mach-tegra/board-trimslice-pinmux.c      |  366 ++-
>  arch/arm/mach-tegra/include/mach/pinconf-tegra.h  |   63 +
>  arch/arm/mach-tegra/include/mach/pinmux-tegra20.h |  184 -
>  arch/arm/mach-tegra/include/mach/pinmux-tegra30.h |  320 --
>  arch/arm/mach-tegra/include/mach/pinmux.h         |  302 --
>  arch/arm/mach-tegra/pinmux-tegra20-tables.c       |  244 --
>  arch/arm/mach-tegra/pinmux-tegra30-tables.c       |  376 ---
>  arch/arm/mach-tegra/pinmux.c                      |  987 ------
>  drivers/pinctrl/Kconfig                           |   15 +
>  drivers/pinctrl/Makefile                          |    3 +
>  drivers/pinctrl/pinctrl-tegra.c                   |  559 +++
>  drivers/pinctrl/pinctrl-tegra.h                   |  163 +
>  drivers/pinctrl/pinctrl-tegra20.c                 | 2860 ++++++++++++++++
>  drivers/pinctrl/pinctrl-tegra30.c                 | 3726 +++++++++++++++++++++
>  21 files changed, 8482 insertions(+), 2960 deletions(-)
> 
> It's still pretty big, adding some 6000 lines in sum total, but you've made
> your case for having all information about the hardware in the driver
> quite clear so I've not got much more to say. Short story: the driver knows
> all about what the hardware can do, and the platform data or device
> tree will decide how these capabilities are employed on a certain
> system.
> 
> What is nice is to have this out of the ARM tree and under pinctrl
> subsystem control.
> 
Heh, omap and imx have a much big SoC family than tegra.  Imaging what
if omap and imx do the same thing here, probably will move Linus'
attention from arch/arm/ to drivers/pinctrl :)

Fortunately, it seems omap and imx will try to get those huge data out
of the driver/kernel.

-- 
Regards,
Shawn
