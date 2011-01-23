Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1AWL2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 06:28:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1AWL2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 06:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kAm+tZTGd+pLsUw00pED5akNTttbd7tpGXCdQiIXruHGyOTmVqfe1FPik7gyXDDHb2
         qBUgpuTFK3l5TjTBlWdU5+3VKW2rzj60SR0YrRoNLPjRckeYU2uXGXDs8AwcWi9Ik30u
         Bi7GO6sSBHhyT2Vagivv7bi72lXyk/f8V6dIA=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Disable high-precision vblank timestamping for UMS
Date: Sun, 23 Jan 2011 11:28:22 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101230932.49998.chris2553@googlemail.com> <1295779801-8118-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295779801-8118-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101231128.22951.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Sunday 23 January 2011, Chris Wilson wrote:
> We only have sufficient information for accurate (sub-frame) timestamping
> when the modesetting is under our control.
>
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_drv.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.c
> b/drivers/gpu/drm/i915/i915_drv.c index 59eb19b..66796bb 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -752,6 +752,9 @@ static int __init i915_init(void)
>  		driver.driver_features &= ~DRIVER_MODESET;
>  #endif
>
> +	if (!(driver.driver_features & DRIVER_MODESET))
> +		driver.get_vblank_timestamp = NULL;
> +
>  	return drm_init(&driver);
>  }

With this patch (and the earlier one) applied, X still doesn't start. At the end 
of xorg's log file I see:

Fatal server error:
Failure to wait for IRQ: No such device

and in the kernel log I see:

Jan 23 11:15:25 upstairs kernel: [drm] Initialized drm 1.1.0 20060810
Jan 23 11:15:26 upstairs kernel: pci 0000:00:02.0: PCI INT A -> GSI 16 (level, 
low) -> IRQ 16
Jan 23 11:15:26 upstairs kernel: pci 0000:00:02.0: setting latency timer to 64
Jan 23 11:15:26 upstairs kernel: ioremap error for 0xbdce0000-0xbdce3000, 
requested 0x10, got 0x0
Jan 23 11:15:26 upstairs kernel: [drm] Supports vblank timestamp caching Rev 1 
(10.10.2010).
Jan 23 11:15:26 upstairs kernel: [drm] No driver support for vblank timestamp 
query.
Jan 23 11:15:26 upstairs kernel: [drm] Initialized i915 1.6.0 20080730 for 
0000:00:02.0 on minor 0

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
