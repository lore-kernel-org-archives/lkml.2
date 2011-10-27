Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1J0IJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:09:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54007 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab1J0IJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:09:56 -0400
Date: Thu, 27 Oct 2011 10:09:53 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Subject: Re: [PATCH v3 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111027080953.GB18360@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-2-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-2-git-send-email-rnayak@ti.com>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:22PM +0530, Rajendra Nayak wrote:

> +	min_uV = of_get_property(np, "regulator-min-uV", NULL);
> +	if (min_uV)
> +		(*init_data)->constraints.min_uV = be32_to_cpu(*min_uV);
> +	max_uV = of_get_property(np, "regulator-max-uV", NULL);
> +	if (max_uV)
> +		(*init_data)->constraints.max_uV = be32_to_cpu(*max_uV);

If we have min_uV and max_uV we should also set REGULATOR_CHANGE_VOLTAGE
(and similarly for the currents).  

We should also have a way to enable status changes - since there's an
always_on property (which does make sense) I'd suggest that as a first
pass we should enable status changes if always_on is not set (these two
things are a bit redundant in the existing constrints).  This is
slightly risky as you can get a situation where new device driver
support for regulators starts unexpectedly turning off supplies but
that's always going to be a risk with constraints disassociated from the
kernel.
