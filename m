Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1GTSpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:45:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46847 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1GTSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:45:16 -0400
Date: Wed, 20 Jul 2011 12:45:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720184516.GF4642@ponder.secretlab.ca>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720182823.GD4642@ponder.secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEEFA@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEEFA@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:33:56AM -0700, Stephen Warren wrote:
> Grant Likely wrote at Wednesday, July 20, 2011 12:28 PM:
> > On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> > > Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:
> > > > Everything required to populate NVIDIA Tegra devices from the device
> > > > tree.  This patch adds a new DT_MACHINE_DESC() which matches against
> > > > a tegra20 device tree.  So far it only registers the on-chip devices,
> > > > but it will be refined in follow on patches to configure clocks and
> > > > pin IO from the device tree also.
> ...
> > > > diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
> > >
> > > tegra-*.dts don't include status="disable" for all the unused controllers.
> > > Should that be added?
> > 
> > I dropped that pattern since my preference has been to have boards
> > explicitly disable unused cores and that has generally been the
> > pattern on other DT platforms.
> 
> Sorry if I wasn't clear, but what I meant was that the board-specific
> files tegra-harmony.dts and tegra-seaboard.dts don't include the status=
> "disable" entries for the modules/ports they don't use.
> 
> Still, everything probably works OK without that...

For eval platforms, unless it is actively dangerous I would leave
devices enabled.  If it is actively dangerous (or potentially so) then
that is an argument to disable by default in the tegra20.dtsi file,
but I've not yet run into any situations like that.

g.
