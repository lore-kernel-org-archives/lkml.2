Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1I3DeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:34:06 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37712 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab1I3DeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:34:04 -0400
X-Sasl-enc: UYwhNuwQBP0f/qHG11x2cnnB6k82aKFvhKxaoZ+VODLl 1317353643
Date: Thu, 29 Sep 2011 20:33:56 -0700
From: Greg KH <greg@kroah.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 00/24] MacBook Air patch sequence (v2)
Message-ID: <20110930033356.GA11621@kroah.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:32PM -0700, Keith Packard wrote:
> Ok, so I've split all of the changes into bite-sized pieces so that
> they should make sense individually now. I've also added the same
> asynchronous power control to the panel power, this reduces the
> module load time down to about 700ms on my MacBook Air, which is
> pretty nice.
> 
> Given the length of the series, I don't think this should all land in
> 3.1, however I'd like opinions on whether I should push this subset,
> which makes the MacBook Air work, into drm-intel-fixes and send that
> along.
> 
>  [PATCH 01/21] drm/i915: Enable digital port hotplug on PCH systems
>  [PATCH 02/21] drm/i915: Shut down PCH interrupts during
>  [PATCH 03/21] drm/i915: Remove extra 300ms delay during eDP mode
>  [PATCH 04/21] drm/i915: Only use VBT panel mode on eDP if no EDID is
>  [PATCH 05/21] drm/i915: Check eDP power when doing aux channel
>  [PATCH 06/21] drm/i915: Unlock PCH_PP_CONTROL always
>  [PATCH 07/21] drm/i915: Check for eDP inside
>  [PATCH 08/21] drm/i915: Turn force VDD back off when panel running
>  [PATCH 09/21] drm/i915: Delay DP i2c initialization until panel
>  [PATCH 10/21] drm/i915: Wrap DP EDID fetch functions to enable eDP
>  [PATCH 11/21] drm/i915: Enable eDP panel power during I2C
>  [PATCH 12/21] drm/i915: Ensure eDP powered up during DP_SET_POWER
>  [PATCH 13/21] drm/i915: Place long delays after each eDP VDD
>  [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay
> 
> The diffstat for that sequence is:
> 
>  i915_drv.h |    1 
>  i915_irq.c |   28 ++++++++
>  i915_reg.h |    6 +
>  intel_dp.c |  194 ++++++++++++++++++++++++++++++++++++++++++++++---------------
>  4 files changed, 180 insertions(+), 49 deletions(-)
> 
> This might be too big at this point in the 3.1 release, so perhaps
> just marking these with a Cc: to stable would be more appropriate.

Are these really all -stable material?

I'm all for enabling new hardware like this, and overall, the patches
aren't that bad, just want to verify this.

And, I do have to tell you, "curses, now I have no excuse to not buy
that laptop!"

greg k-h
