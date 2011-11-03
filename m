Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1KCKC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:02:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52929 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1KCKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:02:55 -0400
Date: Thu, 3 Nov 2011 10:02:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/8] arm/tegra: prepare early init for multiple
	tegra variants
Message-ID: <20111103100235.GK12913@n2100.arm.linux.org.uk>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com> <1320242948-21061-3-git-send-email-pdeschrijver@nvidia.com> <CAMbhsRSTcR8qgYESmM6OxkXeVeg6vS49woCe_OX6CY4pAj2g_A@mail.gmail.com> <20111103092116.GO13358@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103092116.GO13358@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 11:21:16AM +0200, Peter De Schrijver wrote:
> On Wed, Nov 02, 2011 at 07:30:43PM +0100, Colin Cross wrote:
> > On Wed, Nov 2, 2011 at 7:09 AM, Peter De Schrijver
> > <pdeschrijver@nvidia.com> wrote:
> > > This patch splits the early init code in a common and a tegra20 specific part.
> > > L2 cache initialization is generalized and discovers the cache associativity
> > > at runtime.
> > >
> > > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > > ---
> > <snip>
> > 
> > > -static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> > > +void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
> > > +
> > This is unrelated to the patch description?
> > 
> 
> This is a left over from the past. Will be removed from the next version.

Please can Tegra move over to hooking the restart via arm_pm_restart()
rather than via arch_reset()?  That would leave arch_reset() for
software-based reboot methods - which I suspect Tegra doesn't use.

That would allow Tegra to dovetail into the arch_reset cleanup work much
better than it would otherwise do.
