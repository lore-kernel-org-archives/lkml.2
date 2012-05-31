Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab2EaTSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:18:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6849 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2EaTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:18:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6728"; a="194191828"
Message-ID: <7155413ec18f57c1151a29992be32b1f.squirrel@www.codeaurora.org>
Date: Thu, 31 May 2012 12:18:16 -0700 (PDT)
Subject: Re: [PATCH v6 2/3] mmc: core: Support packed write command for     
      eMMC4.5 device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        merez@codeaurora.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1313,10 +1609,17 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
*mq, struct request *rqc)
>  			 * A block was successfully transferred.
>  			 */
>  			mmc_blk_reset_success(md, type);
> -			spin_lock_irq(&md->lock);
> -			ret = __blk_end_request(req, 0,
> +
> +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> +				ret = mmc_blk_end_packed_req(mq, mq_rq);
If a specific request in the packed request consistantly fails, there is
nothing to stop us from sending the same packed request in an endless
loop.
> +				break;

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




