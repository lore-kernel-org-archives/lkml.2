Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1IPG11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:27:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50020 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1IPG1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:27:25 -0400
Date: Thu, 15 Sep 2011 23:27:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 4/8] Input: twl6040-vibra: Check the selected path for
 vibra
Message-ID: <20110916062719.GB6731@core.coreip.homeip.net>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
 <1316091561-30899-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316091561-30899-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 03:59:17PM +0300, Peter Ujfalusi wrote:
> The VIBSELL/R bit in the VIBCTLL/R register tells the source of the data,
> which is going to be used to drive the attached motor(s).
> Do not allow effect execution if any of the channels are set to receive
> audio data.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/input/misc/twl6040-vibra.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
> index cb74185..fe624f2 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -201,6 +201,13 @@ static int vibra_play(struct input_dev *input, void *data,
>  	struct vibra_info *info = input_get_drvdata(input);
>  	int ret;
>  
> +	/* Do not allow effect, while the routing is set to use audio */
> +	ret = twl6040_get_vibralr_status(info->twl6040);
> +	if (ret & TWL6040_VIBSEL) {
> +		dev_info(&input->dev, "Vibra is configured for audio\n");
> +		return -EPERM;
> +	}
> +

This is not very helpful for the application trying to use the device.
Maybe we should zap the device when channels are routed through audio
instead of dripping requests?

Thanks.

-- 
Dmitry
