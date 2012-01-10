Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2AJOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:11:43 -0500
Received: from imta21.fe.bosch.de ([139.15.243.226]:30016 "EHLO
	imta21.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2AJOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:11:42 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jan 2012 09:11:42 EST
Message-ID: <4F0C44F1.9060703@de.bosch.com>
Date: Tue, 10 Jan 2012 15:02:25 +0100
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Richard Zhao <richard.zhao@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "eric.miao@linaro.org" <eric.miao@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: Re: [PATCH 5/6] dma/imx-sdma: use num_events to validate event_id0
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org> <1326178910-14044-5-git-send-email-richard.zhao@linaro.org>
In-Reply-To: <1326178910-14044-5-git-send-email-richard.zhao@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.217.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.01.2012 08:01, Richard Zhao wrote:
> event number is not always 32. use num_events for checking instead.
> 
> Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> ---
>  drivers/dma/imx-sdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 015d93f..22fd561 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -723,7 +723,7 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
>  	sdmac->per_addr = 0;
>  
>  	if (sdmac->event_id0) {
> -		if (sdmac->event_id0 > 32)
> +		if (sdmac->event_id0 >= sdmac->sdma->num_events)
>  			return -EINVAL;
>  		sdma_event_enable(sdmac, sdmac->event_id0);
>  	}

In your git you have

http://git.linaro.org/gitweb?p=people/riczhao/linux-2.6.git;a=commitdiff;h=4bd46e7f8ade05984ee89222bc0523b656d017d2

-       if (sdmac->event_id0) {
-               if (sdmac->event_id0 > 32)
-                       return -EINVAL;
+       if (sdmac->event_id0)
                 sdma_event_enable(sdmac, sdmac->event_id0);

I your git version outdated and replaced by this patch?

Best regards

Dirk
