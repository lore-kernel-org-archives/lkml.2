Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab2BJE6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 23:58:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9653 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab2BJE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 23:58:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Feb 2012 20:58:25 -0800
Message-ID: <4F34A3EF.3070207@nvidia.com>
Date: Thu, 09 Feb 2012 20:58:23 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 0/3] pinctrl: move the core per-device handlers to core
References: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 11:00 AM, Linus Walleij wrote:
> After discussing with some people involved with pin control, we agreed
> that it will just cause trouble to have separate handles for pin muxing
> and pin configuration in callers - they will definately want to set all
> pin aspects regarding muxing and other configuration with one single
> call.
> 
> These three patches take the first step in this transformation by moving
> the per-device handles over to core code, and renaming all related
> functions with the pinctrl_* prefix.

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>

Note that this series will cause some compile breakage in the series I
previously posted to add a pinctrl-tegra driver and convert mach-tegra
to use it. The following patches in that series should still be OK:

pinctrl: add a driver for NVIDIA Tegra
ARM: tegra: Select PINCTRL Kconfig variables

... so you can still go ahead and apply those, but the following will be
broken:

ARM: tegra: Switch to new pinctrl driver
ARM: tegra: Remove pre-pinctrl pinmux driver

also the separately posted:

ARM: tegra: Add pinmux board file for Cardhu

I'll probably hold off reposting those last 3; with any luck they'll be
eclipsed by my implementing full DT binding support in the near future,
given our consensus on that topic following discussion at Linaro Connect.

-- 
nvpublic
