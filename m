Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2HIKgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:36:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769Ab2HIKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:36:03 -0400
Date: Thu, 9 Aug 2012 11:36:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120809103600.GI24328@opensource.wolfsonmicro.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
 <20120808131356.GS16861@opensource.wolfsonmicro.com>
 <50226CF4.1010202@ti.com>
 <20120808135253.GC16861@opensource.wolfsonmicro.com>
 <502274DA.9020204@ti.com>
 <20120808141849.GA24328@opensource.wolfsonmicro.com>
 <50227837.10400@ti.com>
 <20120808144933.GC24328@opensource.wolfsonmicro.com>
 <50238E8A.5030902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50238E8A.5030902@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 01:18:50PM +0300, Peter Ujfalusi wrote:
> On 08/08/2012 05:49 PM, Mark Brown wrote:

> > That makes sense if the GPIO is actively driven, open drain should be
> > better here, but it's still a generic thing which it'd be nice to
> > extract.

> To cover all of this in a generic way is not that straight forward IMHO.

The sequence is just:

  1. Enable mutes (at _PRE time)
  2. Do whatever the device needs
  3. Disable the mutes (at _POST time)

I'm not sure there's any reason for you not to use the internal mute
even if the external mute is present but if there is that's the only
thing that's weird here.  If there's no reason not to do it it just goes
into step 2 and then it's fine, even if there is you can make it
conditional in step 2.

> Sure I could do this:
> hs_extmute: if only this is set we shall use the chip built in functionality
> hs_extmute_gpio: if this is set we use the extmute feature but with external
>                  GPIO.

> But both need to be documented and supported.

Is there any actual case where an external mute is supplied via a
mechanism other than a GPIO, and if there is would it not either need
its own DT property or already need to interact with the driver from
code, making the DT property redundant?  My thinking here is that the
flag should be redundant because we already need to specify how we do
the mute, what I'd expect is that we activate the external mute
functionality as a result of being given another way of doing it so we
don't need to provide a flag.
