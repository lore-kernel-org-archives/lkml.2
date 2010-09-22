Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0IVF6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:58:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49779 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0IVF6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=prWRUo4iSFOrNNyT1LX9uXTb1KEEduDnAs3FwBPT08KCVgB1wQ0cV0o4u0OJyeTsJx
         kyQAwG1lNCCvIWLhIlCAClnM5XOcHjCdLWX9v9TuPODWCFud1IKojjEWtdTOBZVwhtoQ
         6pf5AB46S7fj3GXi+VJbSCKCariza4Psonk34=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Date: Wed, 22 Sep 2010 08:57:30 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r8-anarsoul; KDE/4.5.1; i686; ; )
Cc: Paolo Ornati <ornati@gmail.com>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <20100921202607.2b46ffca@gmail.com> <20100921155653.440afea4@jbarnes-desktop>
In-Reply-To: <20100921155653.440afea4@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009220857.30980.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 of September 2010 01:56:53 Jesse Barnes wrote:
 
> Can you guys try something like this?  My theory is that 945GM has some
> power management behavior we're failing to configure correctly.  If
> disabling it works, then it's likely related.

Nope, it doesn't help, sorry

> diff --git a/drivers/gpu/drm/i915/intel_display.c
> b/drivers/gpu/drm/i915/intel_d index 40cc5da..26e1d23 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -5786,6 +5786,10 @@ void intel_init_clock_gating(struct drm_device *dev)
>                                    I915_READ(MCHBAR_RENDER_STANDBY) &
> ~RCX_SW_EX }
>         }
> +
> +
> +       /* Disable power management on 945GM */
> +       I915_WRITE(0x10f10, 0);
>  }
> 
>  /* Set up chip specific display functions */
