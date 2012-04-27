Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab2D0IyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:54:17 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:34839 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab2D0IyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:54:15 -0400
Date: Fri, 27 Apr 2012 16:54:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cjb@laptop.org, b20223@freescale.com
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427085402.GV2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335451227-27709-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:40:25PM +0800, Dong Aisheng wrote:
> +/**
> + * struct imx_pin_reg - describe a pin reg map
> + * The last 3 members are used for select input setting
> + * @pid: pin id
> + * @mux_reg: mux register offset
> + * @conf_reg: config register offset
> + * @mux_mode: mux mode
> + * @input_reg: select input register offset for this mux if any
> + *  0 if no select input setting needed.
> + * @input_val: the value set to select input register
> + */
> +struct imx_pin_reg {
> +	unsigned int pid;
> +	unsigned int mux_reg;
> +	unsigned int conf_reg;
> +	unsigned int mux_mode;
> +	unsigned int input_reg;
> +	unsigned int input_val;
> +};

Since the array of this struct is big, I would suggest define the type
of the members as size-efficient as possible, for example, u16 is enough
for pid, and reg offset, while u8 is enough for mux_mode?

-- 
Regards,
Shawn
