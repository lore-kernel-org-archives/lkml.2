Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab2HHNw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:52:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52783 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030268Ab2HHNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:52:55 -0400
Date: Wed, 8 Aug 2012 14:52:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120808135253.GC16861@opensource.wolfsonmicro.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
 <20120808131356.GS16861@opensource.wolfsonmicro.com>
 <50226CF4.1010202@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50226CF4.1010202@ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:43:16PM +0300, Peter Ujfalusi wrote:
> On 08/08/2012 04:13 PM, Mark Brown wrote:

> > This doesn't seem like something that should be in the CODEC driver
> > really, there's a general need for something which can unmute controls
> > at the end of the power up sequence and mute before power down.  Also,
> > if this is going to be part of the binding shouldn't we just omit the
> > first property and simply check for the presence of the property which
> > specifies the GPIO?

> The hs_extmute is used for reducing pop noise on the headset. The sequence is
> described in the TRM and it need to be done within the codec driver since it
> is within the sequence.

Is the point it's at in the sequence the end?

> >> +#ifdef CONFIG_OF
> >> +	if (of_find_node_by_name(node, "codec"))
> >> +		return true;
> >> +#endif

> > This really seems like we should be stubbing out of_find_node_by_name()
> > to return false in non-OF cases.

> Yes, most likely the of_find_node_by_name() deserves the same treatment as
> some selected of_* function in case CONFIG_OF is not selected.
> But at the moment this is not the case, we need to protect with ifdef since we
> might break other randconfigs where CONFIG_OF is not set.

We can always add a patch stubbing it out as part of the series, or in a
branch in the OF tree that we can pull in.

> 
> >> +#ifdef CONFIG_OF
> >> +	if (!of_property_read_u32(node, "ti,enable-vibra", &vibra) && vibra)
> >> +		return true;
> >> +#endif
> > 
> > Similarly here.
> 
> Here the ifdef is no needed. of_property_read_u32() return -ENOSYS in case
> CONFIG_OF is not selected.
> 
> -- 
> Péter
