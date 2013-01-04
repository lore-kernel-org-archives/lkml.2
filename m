Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3ADRWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:22:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49206 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3ADRWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:22:49 -0500
Message-ID: <50E70FE5.9010001@wwwdotorg.org>
Date: Fri, 04 Jan 2013 10:22:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/9] Migrate Tegra to common clock framework
References: <1357292453-28418-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357292453-28418-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 02:40 AM, Prashant Gaikwad wrote:
> This patchset does following:
> 1. Decompose single tegra clock structure into multiple clocks.
> 2. Try to use standard clock types supported by common clock framework.
> 3. Use dynamic initialization.
> 4. Move all clock code to drivers/clk/tegra from mach-tegra.
> 5. Add device tree support for Tegra20 and Tegra30 clocks.
> 6. Remove all legacy clock code from mach-tegra.

I think there are bugs here. I applied all your clock patches on top of
Tegra's for-next (see list below), and found that the following don't
work on Springbank:

* HDMI display
* Audio playback
* WiFi

I imagine the same issue would be seen on Harmony or Ventana since
they're very similar. All of those functions work fine with Tegra's
for-next branch (commit 5e30b49 "Merge branch 'for-3.9/defconfig' into
for-next").

I didn't try Tegra30. I assume you'll test both SoCs...

864e964 clk: vexpress: Use common of_clk_init() function
c4e8389 clk: zynq: Use common of_clk_init() function
2c9ff0c clk: vt8500: Use common of_clk_init() function
db9c59c clk: highbank: Use common of_clk_init() function
b40949b clk: sunxi: Use common of_clk_init() function
f6d1492 clk: tegra: Use common of_clk_init() function
f6fd2eb clk: add common of_clk_init() function
70a8ea3 clk: tegra30: remove unused TEGRA_CLK_DUPLICATE()s
3945e4f clk: tegra20: remove unused TEGRA_CLK_DUPLICATE()s
587bcca arm: tegra30: remove auxdata
52b982f arm: tegra20: remove auxdata
3381359 ASoC: tegra: remove auxdata
d31ea1b ARM: dt: tegra30: Add clock information
542ddb5 ARM: dt: tegra20: Add clock information
dd19f5f arm: tegra: Remove legacy clock code
aaf17b6 arm: tegra: Migrate to new clock code
458a3ae clk: tegra: add clock support for tegra30
edb65f1 clk: tegra: add clock support for tegra20
1786e1f ARM: Tegra: Define Tegra30 CAR binding
7d77415 ARM: tegra: Define Tegra20 CAR binding
a4798fa arm: tegra: Move tegra_cpu_car.h to linux/clk/tegra.h
df05a02 clk: tegra: Add tegra specific clocks
ad00a81 ARM: tegra: Add function to read chipid

