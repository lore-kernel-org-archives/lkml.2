Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1GYT64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:58:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:36272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1GYT6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:58:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="29934840"
Subject: Re: [PATCH] iwlagn: check for !priv->txq in
 iwlagn_wait_tx_queue_empty
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1311622702-4807-1-git-send-email-keithp@keithp.com>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 12:21:55 -0700
Message-ID: <1311621715.5579.138.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 12:38 -0700, Keith Packard wrote:
> If the interface is down, txq is NULL. iwlagn_wait_tx_queue_empty
> needs to check for this case to avoid dereferencing that pointer.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
> 
> This is on top of v3.0
> 
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index f803fb6..d6ae444 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1487,6 +1487,9 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
>  	unsigned long now = jiffies;
>  	int ret = 0;
>  
> +	if (!priv->txq)
> +		return 0;
> +
>  	/* waiting for all the tx frames complete might take a while */
>  	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
>  		if (cnt == priv->cmd_queue)

but why you need it?, "start device" call will fail if can not allocate
priv->txq

Thanks
Wey

