Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab2BOJgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:36:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31633 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2BOJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:36:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6620"; a="163301714"
Message-ID: <fd4b8ef9df0d19e20c07923077937231.squirrel@www.codeaurora.org>
In-Reply-To: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
Date: Wed, 15 Feb 2012 01:36:52 -0800 (PST)
Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1065,12 +1075,60 @@ static int mmc_blk_err_check(struct mmc_card
> *card,
>  	if (!brq->data.bytes_xfered)
>  		return MMC_BLK_RETRY;
>
> +	if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> +		if (unlikely(brq->data.blocks << 9 != brq->data.bytes_xfered))
> +			return MMC_BLK_PARTIAL;
> +		else
> +			return MMC_BLK_SUCCESS;
> +	}
> +
>  	if (blk_rq_bytes(req) != brq->data.bytes_xfered)
>  		return MMC_BLK_PARTIAL;
>
>  	return MMC_BLK_SUCCESS;
>  }
I think it would be best to keep the request length (brq->data.blocks << 9
or blk_rq_bytes(req)) in a variable and use it in the original if above.
This way you can avoid doubling the exit points from the function.
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum



