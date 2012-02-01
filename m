Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2BAIUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:20:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65061 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2BAIUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:20:11 -0500
Date: Wed, 1 Feb 2012 00:20:11 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: tegra: Switch to new pinctrl driver
Message-ID: <20120201082011.GK7399@quad.lixom.net>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
 <1327083746-31430-3-git-send-email-swarren@nvidia.com>
 <CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:36:51PM +0100, Linus Walleij wrote:
> On Fri, Jan 20, 2012 at 7:22 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > * Rename old pinmux and new pinctrl platform driver and DT match table
> >  entries, so the new driver gets instantiated.
> > * Re-write board-pinmux.c, so that it uses pinctrl APIs to configura the
> >  pinmux.
> > * Re-write board-*-pinmux.c so that the pinmux configuration tables are
> >  in pinctrl format.
> >
> > Ventana's pin mux table needed some edits on top of the basic format
> > conversion, since some mux options that were previously marked as
> > reserved are now valid in the new pinctrl driver. Attempting to use the
> > old reserved names will result in a failure. Specifically, groups lpw0,
> > lpw2, lsc1, lsck, and lsda were changed from function rsvd4 to displaya,
> > and group pta was changed from function rsvd2 to hdmi.
> >
> > All boards' pin mux tables needed some edits on top of the based format
> > conversion, since function i2c was split into i2c1 (first general I2C
> > controller) and i2cp (power I2C controller) to better align function
> > definitions with HW blocks.
> >
> > Due to the split of mux tables into pure mux and pull/tristate tables,
> > many entries in the separate Seaboard/Ventana tables could be merged
> > into the common table, since the entries differed only in the portion
> > in one of the tables, not both.
> >
> > Most pin groups allow configuration of mux, tri-state, and pull. However,
> > some don't allow pull configuration, which is instead configured by new
> > groups that only allow pull configuration. This is a reflection of the
> > true HW capabilities, which weren't fully represented by the old pinmux
> > driver. This required adding new pull table entries for those new groups,
> > and setting many other entries' pull configuration to
> > TEGRA_PINCONFIG_DONT_SET.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/board-harmony-pinmux.c   |  362 ++++++++++++++-------
> >  arch/arm/mach-tegra/board-paz00-pinmux.c     |  362 ++++++++++++++-------
> >  arch/arm/mach-tegra/board-pinmux.c           |   62 ++++-
> >  arch/arm/mach-tegra/board-pinmux.h           |   39 ++-
> >  arch/arm/mach-tegra/board-seaboard-pinmux.c  |  442 ++++++++++++++++---------
> >  arch/arm/mach-tegra/board-trimslice-pinmux.c |  366 ++++++++++++++--------
> >  arch/arm/mach-tegra/pinmux.c                 |    6 +-
> >  drivers/pinctrl/pinctrl-tegra.c              |    6 +-
> >  8 files changed, 1095 insertions(+), 550 deletions(-)
> 
> Can I have Colin's or Olof's ACK on this Tegra stuff too?
> Would feel better...
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

This series is:

Acked-by: Olof Johansson <olof@lixom.net>

This should go in through the pinctrl tree, but we have at least one patch
already that depends on it (for cardhu pinmux tables). Since cardhu is still
a quite active board, I expect we might see more patches this merge window,
etc. So I'd like to take that patch (that is not part of this series) through
linux-tegra to reduce conflicts.

To facilitate that, can you land this series in a stable branch in
your tree that you promise not to rebase between now and upstream
submission? That would take care of the dependencies quite nicely,
since we can pull that in as a prereq on the cardhu patch that way.

But all h*ll breaks loose if you rebase that branch... So we need a
strong agreement on that.


-Olof

