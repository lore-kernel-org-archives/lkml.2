Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1JJRW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:22:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60116 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab1JJRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:22:25 -0400
Date: Mon, 10 Oct 2011 18:22:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111010172222.GG3607@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318263578-7407-4-git-send-email-rnayak@ti.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:49:36PM +0530, Rajendra Nayak wrote:

> +- regulator-change-voltage: boolean, Output voltage can be changed by software
> +- regulator-change-current: boolean, Output current can be chnaged by software
> +- regulator-change-mode: boolean, Operating mode can be changed by software
> +- regulator-change-status: boolean, Enable/Disable control for regulator exists
> +- regulator-change-drms: boolean, Dynamic regulator mode switching is enabled
> +- regulator-mode-fast: boolean, allow/set fast mode for the regulator
> +- regulator-mode-normal: boolean, allow/set normal mode for the regulator
> +- regulator-mode-idle: boolean, allow/set idle mode for the regulator
> +- regulator-mode-standby: boolean, allow/set standby mode for the regulator
> +- regulator-input-uV: Input voltage for regulator when supplied by another regulator
> +- regulator-always-on: boolean, regulator should never be disabled

Thinking about this I'm not sure that these should go in the device
tree, they're as much talking about what Linux is able to cope with as
they are talking about what the hardware is able to do.  Sometimes
they'll be fixed by the design but they are sometimes also restricted by
what the software is currently capable of.  DRMS is a prime example
here, it depends on how good we are at telling the API about how much
current we're using.
