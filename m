Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2DMSRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:17:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49540 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2DMSRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:17:14 -0400
MIME-Version: 1.0
In-Reply-To: <1334333915-1174-1-git-send-email-b29396@freescale.com>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
Date: Sat, 14 Apr 2012 02:17:13 +0800
Message-ID: <CAA+hA=QaD=wzJoeNUxDqwAJ1grBiPxSKY+_cwYgNMBuaF4OJ6w@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
From: Dong Aisheng <dongas86@gmail.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:18 AM, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
>
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
>
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  .../bindings/pinctrl/fsl,imx6q-pinctrl.txt         |  201 ++++++
>  drivers/pinctrl/Kconfig                            |    4 +
>  drivers/pinctrl/Makefile                           |    1 +
>  drivers/pinctrl/pinctrl-imx.c                      |  716 ++++++++++++++++++++
>  drivers/pinctrl/pinctrl-imx.h                      |  117 ++++
>  5 files changed, 1039 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
>  create mode 100644 drivers/pinctrl/pinctrl-imx.c
>  create mode 100644 drivers/pinctrl/pinctrl-imx.h
>
.........
> +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> +                       struct imx_pinctrl_info *info, u32 index)
> +{
> +       struct device_node *child;
> +       struct imx_pmx_func *func;
> +       struct imx_pin_group *grp;
> +       int ret;
> +       static u32 grp_index;
> +       u32 i = 0;
> +
> +       dev_dbg(info->dev, "parse function(%d): %s\n", index, np->name);
> +
> +       func = &info->functions[index];
> +
> +       /* Initialise function */
> +       func->name = np->name;
> +       func->num_groups = of_get_child_count(np);
The driver depends on another dt patch which seems missed the 3.4 kernel.
[PATCH V3 1/1] dt: add of_get_child_count helper function
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/084327.html
I just sent out the mail to check with Rob.

Regards
Dong Aisheng
