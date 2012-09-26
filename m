Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2IZJcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:32:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58705 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2IZJcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
Date: Wed, 26 Sep 2012 15:02:01 +0530
Message-ID: <CABb+yY36pQ7oXC1OKEQ-1V55c2SZurcTAPaZ=_PWugqxdL2rgg@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 12:11 PM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:

> How about conditionally DMA_TERMINATE_ALL and free resources like below ?
>
> @@ -3017,9 +3017,11 @@ static int __devexit pl330_remove(struct
> amba_device *adev)
>                 /* Remove the channel */
>                 list_del(&pch->chan.device_node);
>
> -               /* Flush the channel */
> -               pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
> -               pl330_free_chan_resources(&pch->chan);
> +               if (pch->chan.client_count != 0) {
> +                       /* Flush the channel */
> +                       pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
> +                       pl330_free_chan_resources(&pch->chan);
> +               }
>         }
>
It is perfectly safe to flush the channels that have client_count == 0
as well. Which is already the case.
