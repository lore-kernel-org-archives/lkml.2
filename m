Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0KWHk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:40:56 -0500
Received: from smtp.nokia.com ([147.243.1.48]:41940 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0KWHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:40:55 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] ASoC: Do not update the cache if write to hardware failed
Date: Tue, 23 Nov 2010 09:39:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo; KDE/4.5.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1290492847.7286.1.camel@mola>
In-Reply-To: <1290492847.7286.1.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011230939.17080.peter.ujfalusi@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 November 2010 08:14:07 ext Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/tpa6130a2.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
> index bfef3da..2d64502 100644
> --- a/sound/soc/codecs/tpa6130a2.c
> +++ b/sound/soc/codecs/tpa6130a2.c
> @@ -77,8 +77,10 @@ static int tpa6130a2_i2c_write(int reg, u8 value)
> 
>  	if (data->power_state) {
>  		val = i2c_smbus_write_byte_data(tpa6130a2_client, reg, value);
> -		if (val < 0)
> +		if (val < 0) {
>  			dev_err(&tpa6130a2_client->dev, "Write failed\n");
> +			return val;
> +		}
>  	}
> 
>  	/* Either powered on or off, we save the context */

Nice catch, thank you!

CC-ing alsa-devel

Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
