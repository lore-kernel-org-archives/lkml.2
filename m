Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2HHOtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:49:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54937 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758653Ab2HHOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:49:36 -0400
Date: Wed, 8 Aug 2012 15:49:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120808144933.GC24328@opensource.wolfsonmicro.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
 <20120808131356.GS16861@opensource.wolfsonmicro.com>
 <50226CF4.1010202@ti.com>
 <20120808135253.GC16861@opensource.wolfsonmicro.com>
 <502274DA.9020204@ti.com>
 <20120808141849.GA24328@opensource.wolfsonmicro.com>
 <50227837.10400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50227837.10400@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 05:31:19PM +0300, Peter Ujfalusi wrote:
> On 08/08/2012 05:18 PM, Mark Brown wrote:

> > I'm struggling to see any reason not to just hold the external mute on
> > for the entire time the headset is powered off?

> I think because it would mean in most cases that we keep a GPIO line enabled
> during the time the HS is not in use, which burns power.
> In most cases the mute is enabled when the GPIO line is up.

That makes sense if the GPIO is actively driven, open drain should be
better here, but it's still a generic thing which it'd be nice to
extract.

Still, the main thing here was the fact that we should be able to drop
the flag for the feature in the first place.
