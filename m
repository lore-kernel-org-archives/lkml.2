Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2AXWo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:44:29 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43669 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2AXWo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:44:26 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-3-git-send-email-swarren@nvidia.com>
	<CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
Date: Tue, 24 Jan 2012 14:44:25 -0800
Message-ID: <CAOesGMjuewhO2H+QFQtAX+xFb5hyNn8Q65Cuup4vaXWAFvX87w@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: tegra: Switch to new pinctrl driver
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 2:36 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Jan 20, 2012 at 7:22 PM, Stephen Warren <swarren@nvidia.com> wrote:
>
>> * Rename old pinmux and new pinctrl platform driver and DT match table
>>  entries, so the new driver gets instantiated.
>> * Re-write board-pinmux.c, so that it uses pinctrl APIs to configura the
>>  pinmux.
>> * Re-write board-*-pinmux.c so that the pinmux configuration tables are
>>  in pinctrl format.
>>
>> Ventana's pin mux table needed some edits on top of the basic format
>> conversion, since some mux options that were previously marked as
>> reserved are now valid in the new pinctrl driver. Attempting to use the
>> old reserved names will result in a failure. Specifically, groups lpw0,
>> lpw2, lsc1, lsck, and lsda were changed from function rsvd4 to displaya,
>> and group pta was changed from function rsvd2 to hdmi.
>>
>> All boards' pin mux tables needed some edits on top of the based format
>> conversion, since function i2c was split into i2c1 (first general I2C
>> controller) and i2cp (power I2C controller) to better align function
>> definitions with HW blocks.
>>
>> Due to the split of mux tables into pure mux and pull/tristate tables,
>> many entries in the separate Seaboard/Ventana tables could be merged
>> into the common table, since the entries differed only in the portion
>> in one of the tables, not both.
>>
>> Most pin groups allow configuration of mux, tri-state, and pull. However,
>> some don't allow pull configuration, which is instead configured by new
>> groups that only allow pull configuration. This is a reflection of the
>> true HW capabilities, which weren't fully represented by the old pinmux
>> driver. This required adding new pull table entries for those new groups,
>> and setting many other entries' pull configuration to
>> TEGRA_PINCONFIG_DONT_SET.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>  arch/arm/mach-tegra/board-harmony-pinmux.c   |  362 ++++++++++++++-------
>>  arch/arm/mach-tegra/board-paz00-pinmux.c     |  362 ++++++++++++++-------
>>  arch/arm/mach-tegra/board-pinmux.c           |   62 ++++-
>>  arch/arm/mach-tegra/board-pinmux.h           |   39 ++-
>>  arch/arm/mach-tegra/board-seaboard-pinmux.c  |  442 ++++++++++++++++---------
>>  arch/arm/mach-tegra/board-trimslice-pinmux.c |  366 ++++++++++++++--------
>>  arch/arm/mach-tegra/pinmux.c                 |    6 +-
>>  drivers/pinctrl/pinctrl-tegra.c              |    6 +-
>>  8 files changed, 1095 insertions(+), 550 deletions(-)
>
> Can I have Colin's or Olof's ACK on this Tegra stuff too?
> Would feel better...
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yup, I've just been waiting on things to settle,
bindings/implementation wise. Will look at it over the next day or two
and get back.


-Olof
