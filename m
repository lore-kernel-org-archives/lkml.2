Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2FKU0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:26:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25629 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2FKU0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:26:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6739"; a="199952125"
Message-ID: <68ac9afd251593ab3df348a469a10adb.squirrel@www.codeaurora.org>
In-Reply-To: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
References: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
Date: Mon, 11 Jun 2012 13:26:53 -0700 (PDT)
Subject: Re: [PATCH v7 1/3] mmc: core: Add packed command feature of eMMC4.5
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, "'Maya Erez'" <merez@codeaurora.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>,
        "'S, Venkatraman'" <svenkatr@ti.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> +			((card->ext_csd.max_packed_writes > 0) ||
> +			(card->ext_csd.max_packed_reads > 0))) {
> +		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +				EXT_CSD_EXP_EVENTS_CTRL,
> +				EXT_CSD_PACKED_EVENT_EN,
> +				card->ext_csd.generic_cmd6_time);
> +		if (err && err != -EBADMSG)
> +			goto free_card;

Subhash suggestion to change to the following is missing:
     if (  (host->caps2 & MMC_CAP2_PACKED_WR &&
card->ext_csd.max_packed_writes > 0) ||
            (host->caps2 & MMC_CAP2_PACKED_RD &&
card->ext_csd.max_packed_reads > 0)

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

