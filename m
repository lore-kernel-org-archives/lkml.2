Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1LMXCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:02:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1LMXCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <1323769253-22580-3-git-send-email-haojian.zhuang@marvell.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-3-git-send-email-haojian.zhuang@marvell.com>
Date: Wed, 14 Dec 2011 00:02:29 +0100
Message-ID: <CACRpkdbqj0zyRP4skGm4EX0Hx1Axe5-wkC14Y6Ee_B9TFzy39g@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] ARM: mmp: enable pinmux in platform driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>, swarren@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:40 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Only enable pinmux in brownstone/aspenite/ttc dkb.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

A very appetizing and appealing patch, this is looking *very good*.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

(But I guess you need the other patch to go in as well...)

> +static struct pinmux_map brownstone_pmx_map[] = {
> +       {
> +               .name = "dkin",
> +               .ctrl_dev_name = "mmp2-pinmux",
> +               .function = "dkin",
> +               .group = "dkin-2-pin",
> +               .hog_on_boot = true,
> +       }, {
> +               .name = "uart1",
> +               .ctrl_dev_name = "mmp2-pinmux",
> +               .function = "uart1",
> +               .group = "uart1-4-pin",
> +               .hog_on_boot = true,
> +       }, {
> +               .name = "uart2",
> +               .ctrl_dev_name = "mmp2-pinmux",
> +               .function = "uart2",
> +               .group = "uart2-4-pin",
> +               .hog_on_boot = true,
> +       },

Looks like we want to add
#define PINMUX_MAP_SYS_HOG_GROUP() or so with four
arguments, what do you say Stephen? Shall I try to patch  in
something like that (then this patch will look even better).

> +       PINMUX_MAP_SYS_HOG("uart3", "mmp2-pinmux", "uart3"),
> +       PINMUX_MAP_SYS_HOG("twsi2", "mmp2-pinmux", "twsi2"),
(...)

Thanks,
Linus Walleij
