Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0KWKZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:25:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51120 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0KWKY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:24:59 -0500
Subject: Re: [PATCH] ASoC: Do not update the cache if write to hardware
 failed
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>
In-Reply-To: <1290492847.7286.1.camel@mola>
References: <1290492847.7286.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 10:24:55 +0000
Message-ID: <1290507895.3449.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 14:14 +0800, Axel Lin wrote:
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

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

