Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HHQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:14:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8370 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1HHQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:14:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 08 Aug 2011 09:13:45 -0700
Date: Mon, 8 Aug 2011 09:13:44 -0700
From: Robert Morell <rmorell@nvidia.com>
To: Dilan Lee <dilee@nvidia.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arun.murthy@stericsson.com" <arun.murthy@stericsson.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Jordan Nien <JNien@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] video: Added a callback 'notify_after' for backlight
 control
Message-ID: <20110808161344.GC27106@morell.nvidia.com>
References: <1312799875-18629-1-git-send-email-dilee@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312799875-18629-1-git-send-email-dilee@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me in principle, but a few nitpicks.
First, the short commit message should be in imperative form, i.e., "Add
a callback..."

On Mon, Aug 08, 2011 at 03:37:55AM -0700, Dilan Lee wrote:
> From: Dilan Lee <dilee@nvidia.com>
> 
> We need a callback to do some things after pwm_enable,pwm_disable
> and pwm_config.

Add a space between "pwm_enable,pwm_disable"

> For example, GPIO backlight_en has to be rised after pwm has been enabled
> to meet panel power on sequence defined in panel specification.

There's a typo in "raised" above, but really, this paragraph should be
omitted entirely.  Without context, it doesn't make any sense.  If
more motivation that the previous paragraph is necessary, maybe add
something like "This may be necessary to properly sequence timing on
certain devices."

>  	unsigned int		lth_brightness;
>  	int			(*notify)(struct device *,
>  					  int brightness);
> +	void		(*notify_after)(struct device *,
> +					  int brightness);

The indentation here looks a bit off; notify_after should be lined up
with notify and check_fb, and int brightness doesn't need the extra
spaces since the notify_after argument list starts on a tab boundary.

Otherwise,

Reviewed-by: Robert Morell <rmorell@nvidia.com>

Thanks,
Robert
