Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1IPJ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:26:47 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54202 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab1IPJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:26:45 -0400
Subject: Re: [PATCH 4/8] Input: twl6040-vibra: Check the selected path for
 vibra
From: Liam Girdwood <lrg@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
In-Reply-To: <1316091561-30899-5-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
	 <1316091561-30899-5-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 10:26:41 +0100
Message-ID: <1316165201.3229.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 15:59 +0300, Peter Ujfalusi wrote:
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

Sorry, missed this earlier.

Probably best to return -EBUSY here otherwise it may look like a device
permissions problem to some users.

Liam


