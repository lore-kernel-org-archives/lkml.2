Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1FIIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:43:56 -0400
Received: from smtp.nokia.com ([147.243.128.24]:24378 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1FIInx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:43:53 -0400
Subject: Re: [PATCH 07/19] mfd: Use mfd cell platform_data for wl1273 cells
 platform bits
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1304901131-7104-8-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
	 <1304901131-7104-8-git-send-email-sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 09 Jun 2011 11:43:49 +0300
Message-ID: <1307609029.6040.0.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 02:31 +0200, ext Samuel Ortiz wrote:
> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.
> 
> Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/media/radio/radio-wl1273.c |    2 +-
>  drivers/mfd/wl1273-core.c          |    6 ++++--
>  sound/soc/codecs/wl1273.c          |    3 +--
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
> index e2550dc..46cacf8 100644
> --- a/drivers/media/radio/radio-wl1273.c
> +++ b/drivers/media/radio/radio-wl1273.c
> @@ -1990,7 +1990,7 @@ static int wl1273_fm_radio_remove(struct platform_device *pdev)
>  
>  static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
>  {
> -	struct wl1273_core **core = mfd_get_data(pdev);
> +	struct wl1273_core **core = pdev->dev.platform_data;
>  	struct wl1273_device *radio;
>  	struct v4l2_ctrl *ctrl;
>  	int r = 0;
> diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
> index 04914f2..63d250d 100644
> --- a/drivers/mfd/wl1273-core.c
> +++ b/drivers/mfd/wl1273-core.c
> @@ -217,7 +217,8 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
>  
>  	cell = &core->cells[children];
>  	cell->name = "wl1273_fm_radio";
> -	cell->mfd_data = &core;
> +	cell->platform_data = &core;
> +	cell->pdata_size = sizeof(core);
>  	children++;
>  
>  	core->read = wl1273_fm_read_reg;
> @@ -231,7 +232,8 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
>  
>  		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
>  		cell->name = "wl1273-codec";
> -		cell->mfd_data = &core;
> +		cell->platform_data = &core;
> +		cell->pdata_size = sizeof(core);
>  		children++;
>  	}
>  
> diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
> index c8a874d..5836201 100644
> --- a/sound/soc/codecs/wl1273.c
> +++ b/sound/soc/codecs/wl1273.c
> @@ -441,8 +441,7 @@ EXPORT_SYMBOL_GPL(wl1273_get_format);
>  
>  static int wl1273_probe(struct snd_soc_codec *codec)
>  {
> -	struct wl1273_core **core =
> -			mfd_get_data(to_platform_device(codec->dev));
> +	struct wl1273_core **core = codec->dev->platform_data;
>  	struct wl1273_priv *wl1273;
>  	int r;
>  

Looks good.

B.R.
Matti A.





