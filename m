Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2EIIfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:35:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8799 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2EIIfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:35:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6705"; a="188909109"
Message-ID: <3f7a217a08fd2c508576cbac8d26b017.squirrel@www.codeaurora.org>
In-Reply-To: <1336054995-22988-15-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
    <1336054995-22988-15-git-send-email-svenkatr@ti.com>
Date: Wed, 9 May 2012 01:35:00 -0700 (PDT)
Subject: Re: [PATCH v2 14/16] mmc: block: Implement HPI invocation and 
     handling logic.
From: kdorfman@codeaurora.org
To: "Venkatraman S" <svenkatr@ti.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk, "Venkatraman S" <svenkatr@ti.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static bool mmc_can_do_foreground_hpi(struct mmc_queue *mq,
> +			struct request *req, unsigned int thpi)
> +{
> +
> +	/*
> +	 * If some time has elapsed since the issuing of previous write
> +	 * command, or if the size of the request was too small, there's
> +	 * no point in preempting it. Check if it's worthwhile to preempt
> +	 */
> +	int time_elapsed = jiffies_to_msecs(jiffies -
> +			mq->mqrq_cur->mmc_active.mrq->cmd->started_time);
> +
> +	if (time_elapsed <= thpi)
> +			return true;
Some host controllers (or DMA) has possibility to get the byte count of
current transaction. It may be implemented as host api (similar to abort
ops). Then you have more accurate estimation of worthiness.

> +
> +	return false;
> +}

Thanks, Kostya

