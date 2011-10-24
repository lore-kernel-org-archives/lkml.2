Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1JXNte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:49:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44165 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932641Ab1JXNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:49:32 -0400
Date: Mon, 24 Oct 2011 15:49:30 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Rajendra Nayak <rnayak@ti.com>,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024134930.GD26033@opensource.wolfsonmicro.com>
References: <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
 <20111024134025.GE1755@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024134025.GE1755@S2100-06.ap.freescale.net>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 09:40:26PM +0800, Shawn Guo wrote:

> +++ b/drivers/regulator/core.c
> @@ -2673,7 +2673,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>         BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
> 
>         /* find device_node and attach it */
> -       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> +       rdev->dev.of_node = of_find_node_by_name(dev->parent->of_node,
> +                                                regulator_desc->name);
> 

Is that going to do the right thing if you've got a MFD which does
register each regulator as a separate device?  Might be best to just
search within dev and get drivers to pass the "real" device in when
registering the regulator rather than the virtual device.
