Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2IKWSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:18:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54630 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2IKWSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:18:38 -0400
Message-ID: <504FB8BA.1010703@wwwdotorg.org>
Date: Tue, 11 Sep 2012 16:18:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/9] pinctrl: mvebu: dove pinctrl driver
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1347266386-16229-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 02:39 AM, Sebastian Hesselbarth wrote:
> This patch adds a SoC specific pinctrl driver for Marvell Dove SoCs
> plus DT binding documentation. This driver will use the mvebu pinctrl
> driver core.

> diff --git a/drivers/pinctrl/pinctrl-dove.c b/drivers/pinctrl/pinctrl-dove.c

> +static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
> +			      unsigned long *config)
> +{
> +	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
> +	unsigned long mask;
> +
> +	switch (ctrl->pid) {
> +	case 24: /* mpp_camera */
> +		mask = DOVE_CAM_GPIO_SEL;
> +		break;
> +	case 40: /* mpp_sdio0 */
> +		mask = DOVE_SD0_GPIO_SEL;
> +		break;
> +	case 46: /* mpp_sdio1 */
> +		mask = DOVE_SD1_GPIO_SEL;
> +		break;
> +	case 58: /* mpp_spi0 */
> +		mask = DOVE_SPI_GPIO_SEL;
> +		break;
> +	case 62: /* mpp_uart1 */
> +		mask = DOVE_UART1_GPIO_SEL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

Wouldn't it be better to use #defines instead of the constants in the
case statements, and also share those #defines with:


> +static struct mvebu_mpp_ctrl dove_mpp_controls[] = {
> +	MPP_FUNC_CTRL(0, 0, "mpp0", dove_pmu_mpp_ctrl),
                      ^^^^

> +static struct mvebu_mpp_mode dove_mpp_modes[] = {
> +	MPP_MODE(0,
                 ^^
