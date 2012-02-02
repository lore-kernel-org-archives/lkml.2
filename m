Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2BBN04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:26:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59315 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2BBN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:26:54 -0500
MIME-Version: 1.0
In-Reply-To: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
Date: Thu, 2 Feb 2012 14:26:54 +0100
Message-ID: <CACRpkda+KCutSFgPwH2Xvd14h0OCrArFGXAidp3n_ZgG28KB5g@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 10:04 PM, Stephen Warren <swarren@nvidia.com> wrote:

> This adds a driver for the Tegra pinmux, and required parameterization
> data for Tegra20 and Tegra30.

OK so I've applied this monster patch and the three others,

the diffstat looks like so:

git diff --stat v3.3-rc2..HEAD
 arch/arm/mach-tegra/Kconfig                       |    4 +
 arch/arm/mach-tegra/Makefile                      |    3 -
 arch/arm/mach-tegra/board-harmony-pinmux.c        |  362 ++-
 arch/arm/mach-tegra/board-paz00-pinmux.c          |  362 ++-
 arch/arm/mach-tegra/board-pinmux.c                |   62 +-
 arch/arm/mach-tegra/board-pinmux.h                |   39 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c       |  442 ++-
 arch/arm/mach-tegra/board-trimslice-pinmux.c      |  366 ++-
 arch/arm/mach-tegra/include/mach/pinconf-tegra.h  |   63 +
 arch/arm/mach-tegra/include/mach/pinmux-tegra20.h |  184 -
 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h |  320 --
 arch/arm/mach-tegra/include/mach/pinmux.h         |  302 --
 arch/arm/mach-tegra/pinmux-tegra20-tables.c       |  244 --
 arch/arm/mach-tegra/pinmux-tegra30-tables.c       |  376 ---
 arch/arm/mach-tegra/pinmux.c                      |  987 ------
 drivers/pinctrl/Kconfig                           |   15 +
 drivers/pinctrl/Makefile                          |    3 +
 drivers/pinctrl/pinctrl-tegra.c                   |  559 +++
 drivers/pinctrl/pinctrl-tegra.h                   |  163 +
 drivers/pinctrl/pinctrl-tegra20.c                 | 2860 ++++++++++++++++
 drivers/pinctrl/pinctrl-tegra30.c                 | 3726 +++++++++++++++++++++
 21 files changed, 8482 insertions(+), 2960 deletions(-)

It's still pretty big, adding some 6000 lines in sum total, but you've made
your case for having all information about the hardware in the driver
quite clear so I've not got much more to say. Short story: the driver knows
all about what the hardware can do, and the platform data or device
tree will decide how these capabilities are employed on a certain
system.

What is nice is to have this out of the ARM tree and under pinctrl
subsystem control.

Olof, Arnd: please verify that this is a direction you accept for the Tegra.
(Olof has already ACK:ed it, mainly thinking about Arnd.)

I've created a separate branch named pinctrl-tegra-for-next for this
series and merged it into my devel and for-next branches and pushed.
As suggested by Olof devel and for-next may be rebased but the
tegra branch will stay intact (fixes on top is OK).

Olof: I've published the pinctrl-tegra-for-next branch based on v3.3-rc2
here:
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
pinctrl-tegra-for-next

Yours,
Linus Walleij
