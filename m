Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2IQLBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:01:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47922 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2IQLBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:01:03 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-87-505702ee46dc
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Inderpal Singh'" <inderpal.singh@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, patches@linaro.org, boojin.kim@samsung.com,
        jassisinghbrar@gmail.com
References: <1347856065-14027-1-git-send-email-inderpal.singh@linaro.org>
In-reply-to: <1347856065-14027-1-git-send-email-inderpal.singh@linaro.org>
Subject: RE: [PATCH] DMA: PL330: return ENOMEM instead of 0 from
 pl330_alloc_chan_resources
Date: Mon, 17 Sep 2012 20:01:01 +0900
Message-id: <050c01cd94c3$b97aaa90$2c6fffb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2UjNMAxW0pbAg+RB2tE93599ulFwANtJ0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd13TOEBBm/nyltc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUsbF7PXtDKUXF67wKWBsZjbF2MnBwSAiYSPVfnMEPY
	YhIX7q0HinNxCAlMZ5TY3L+JFcL5yyjRevw1I0gVm4CGxOH3z9hBbBGBYok7lx6CdTMLJEj0
	dP4CqxES8JS4d+0BWA2ngJfE2ScHmEBsYYFYid75S1lAbBYBVYmOSwvB6nkFbCUunP3MBmEL
	SvyYfI8FYqaWxPqdx5kgbHmJzWveAu3iALpUXeLRX12IE4wklszbygZRIiKx78U7xgmMQrOQ
	TJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pJ9J7WBc2WBxiFGA
	g1GJh9dwUliAEGtiWXFl7iFGCQ5mJRHeB2+AQrwpiZVVqUX58UWlOanFhxilOViUxHmFPwUG
	CAmkJ5akZqemFqQWwWSZODilGhhnT+uI/J+8ZmHBmYdTLG0WZWS9uCiYFq2t/PCj/aPb8z5q
	x8RXJG9JMA5iXHfsVrWzq9wM5gs/bn2el/p+47Q+v6iwqz/zS1fO996/P+nyk0iRamOe87nK
	lr6fd87nYbaTXWCvfjvEL+1qQXHpiYne+bPPRRm5XvArDz+lnOsRVHr0r0ixyAQlluKMREMt
	5qLiRACiIWd4ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inderpal Singh wrote:
> 
> Since 0 is not considered as error at dmaengine level, return ENOMEM
> from pl330_alloc_chan_resources in case of failure.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/dma/pl330.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index e4feba6..14d881c 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2393,7 +2393,7 @@ static int pl330_alloc_chan_resources(struct
> dma_chan *chan)
>  	pch->pl330_chid = pl330_request_channel(&pdmac->pif);
>  	if (!pch->pl330_chid) {
>  		spin_unlock_irqrestore(&pch->lock, flags);
> -		return 0;
> +		return -ENOMEM;
>  	}
> 
>  	tasklet_init(&pch->task, pl330_tasklet, (unsigned long) pch);
> --
> 1.7.9.5

