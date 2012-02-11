Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2BKGTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 01:19:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19546 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2BKGTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 01:19:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 10 Feb 2012 22:19:01 -0800
Message-ID: <4F360853.3050402@nvidia.com>
Date: Fri, 10 Feb 2012 22:18:59 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 0/3] pinctrl: move the core per-device handlers to core
References: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org> <4F34A3EF.3070207@nvidia.com> <CACRpkdZ0kTXLAfdsfMjeZZX4W-fx5zyEdeGboKCmKSzCaMVw_A@mail.gmail.com>
In-Reply-To: <CACRpkdZ0kTXLAfdsfMjeZZX4W-fx5zyEdeGboKCmKSzCaMVw_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 12:51 PM, Linus Walleij wrote:
> On Fri, Feb 10, 2012 at 5:58 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
>>> These three patches take the first step in this transformation by moving
>>> the per-device handles over to core code, and renaming all related
>>> functions with the pinctrl_* prefix.
>>
>> The series,
>> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks, I've managed to push this to -next with the v2 version of
> [2/3] and the hog patch.
> 
>> Note that this series will cause some compile breakage in the series I
>> previously posted to add a pinctrl-tegra driver and convert mach-tegra
>> to use it. The following patches in that series should still be OK:
>>
>> pinctrl: add a driver for NVIDIA Tegra
>> ARM: tegra: Select PINCTRL Kconfig variables
>>
>> ... so you can still go ahead and apply those, but the following will be
>> broken:
>>
>> ARM: tegra: Switch to new pinctrl driver
>> ARM: tegra: Remove pre-pinctrl pinmux driver
>>
>> also the separately posted:
>>
>> ARM: tegra: Add pinmux board file for Cardhu
>>
>> I'll probably hold off reposting those last 3; with any luck they'll be
>> eclipsed by my implementing full DT binding support in the near future,
>> given our consensus on that topic following discussion at Linaro Connect.
> 
> OK, alternatively I could remove these for the time being, or I
> can fix up the mess I created if you prefer, by just adding
> a patch on top, so it gets changed over no matter if the
> DT stuff gets sorted out for this merge window?

I'll probably want to rework the 3 patches your changes break anyway (in
order to completely remove use of board-*-pinmux.c when booting from DT,
once I write the DT code) and so you may as well not apply them, just
the driver itself. It'll save some churn.

-- 
nvpublic
