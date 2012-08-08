Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2HHNOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:14:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33673 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758019Ab2HHNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:13:58 -0400
Date: Wed, 8 Aug 2012 14:13:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120808131356.GS16861@opensource.wolfsonmicro.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 12:41:20PM +0300, Peter Ujfalusi wrote:

> +Required properties:
> +- compatible : must be "ti,twl4030-audio"

So, as I mentioned before I find this sort of direct mapping of the
Linux device representation into the device tree really troubling.
I'm just way too aware of the fact that even the Linux split of these
things can change over time and often represents internal Linux
considerations.

> +-ti,hs_extmute: Use external mute for HS pop reduction
> +-ti,hs_extmute_gpio: Use external GPIO to control the external mute
> +-ti,hs_extmute_disable_level: The desired level of the GPIO line when the
> +			      external mute is disabled. valuse: 0 or 1

This doesn't seem like something that should be in the CODEC driver
really, there's a general need for something which can unmute controls
at the end of the power up sequence and mute before power down.  Also,
if this is going to be part of the binding shouldn't we just omit the
first property and simply check for the presence of the property which
specifies the GPIO?

> +#ifdef CONFIG_OF
> +	if (of_find_node_by_name(node, "codec"))
> +		return true;
> +#endif

This really seems like we should be stubbing out of_find_node_by_name()
to return false in non-OF cases.

> +#ifdef CONFIG_OF
> +	if (!of_property_read_u32(node, "ti,enable-vibra", &vibra) && vibra)
> +		return true;
> +#endif

Similarly here.
