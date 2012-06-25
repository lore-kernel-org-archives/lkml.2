Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2FYMzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:55:39 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:58009 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2FYMzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:55:37 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoxTACVS6E9V5qg+PGdsb2JhbABEihWsChkBAQEBNzSCGAEBBScTHBMBDxAIAw4KLhQlChoTiA+4RBSLH4UiYAOVLYVmjH0
X-IronPort-AV: E=Sophos;i="4.77,471,1336341600"; 
   d="scan'208";a="364757627"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 25 Jun 2012 14:04:07 +0200
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH] HID: magicmouse: Correct report range of major / minor
 axes
Message-ID: <20120625120407.GA522@polaris.bitmath.org>
References: <1340382713-2957-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340382713-2957-1-git-send-email-miletus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:31:53PM -0400, Yufeng Shen wrote:
> In patch "HID: magicmouse: Adjust major / minor axes to scale",
> touch_major and touch_minor axes are scaled by a factor of
> four when reported but the max touch_major/minor is not scaled
> accordingly. This patch scales the max touch_major/minor to
> be consistent with the reported value.
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
> ---
>  drivers/hid/hid-magicmouse.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 7cf3ffe..40ac665 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -426,8 +426,10 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>  		__set_bit(EV_ABS, input->evbit);
>  
>  		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
> -		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 4, 0);
> -		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 4, 0);
> +		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
> +				     4, 0);
> +		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,
> +				     4, 0);
>  		input_set_abs_params(input, ABS_MT_ORIENTATION, -31, 32, 1, 0);
>  
>  		/* Note: Touch Y position from the device is inverted relative
> -- 
> 1.7.7.3
> 

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
