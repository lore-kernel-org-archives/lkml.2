Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2IDLee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:34:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2IDLed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:34:33 -0400
Date: Tue, 4 Sep 2012 19:34:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org
Subject: Re: [PATCH v5 3/4] regulator: anatop-regulator: convert to use
 syscon to access anatop register
Message-ID: <20120904113429.GK2362@S2101-09.ap.freescale.net>
References: <1346728811-25788-1-git-send-email-b29396@freescale.com>
 <1346728811-25788-4-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346728811-25788-4-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 11:20:10AM +0800, Dong Aisheng wrote:
> +
> +	anatop_np = of_get_parent(np);
> +	if (!anatop_np)
> +		return -ENODEV;
> +	sreg->anatop = syscon_node_to_regmap(anatop_np);
> +	if (IS_ERR(sreg->anatop))
> +		return PTR_ERR(sreg->anatop);
> +
With of_node_put moved out from syscon_node_to_regmap, shouldn't
we put anatop_np here then?

-- 
Regards,
Shawn
