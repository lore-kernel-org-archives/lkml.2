Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0KHWMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:12:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:60301 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0KHWMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:12:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,171,1288594800"; 
   d="scan'208";a="675510903"
Subject: Re: [PATCH] iwl3945: Fix oops at module load
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
References: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 14:08:42 -0800
Message-ID: <1289254122.12056.86.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 2010-11-08 at 13:54 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> On my laptop the iwl3945 driver oopsed at boot with 2.6.37-rc1
> in __dev_printk.
> 
> The problem is that for some reason it prints the sw scan
> warning, but does that before the pci device is initialized
> in the driver private structure. This leads to an oops
> in the warning print code.
> 
> Move the warning after the device has been initialized.
> 
> Cc: Johannes.berg@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 8f8c4b7..3910ec2 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -3995,6 +3995,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
>  	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
>  
> +	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
> +	priv->cfg = cfg;
> +	priv->pci_dev = pdev;
> +	priv->inta_mask = CSR_INI_SET_MASK;
> +
>  	/*
>  	 * Disabling hardware scan means that mac80211 will perform scans
>  	 * "the hard way", rather than using device's scan.
> @@ -4004,12 +4009,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  		iwl3945_hw_ops.hw_scan = NULL;
>  	}
>  
> -
> -	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
> -	priv->cfg = cfg;
> -	priv->pci_dev = pdev;
> -	priv->inta_mask = CSR_INI_SET_MASK;
> -
>  	if (iwl_alloc_traffic_mem(priv))
>  		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
>  

I believe the fix already in
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary
commit#6e0922e0781884ff4eb3638f10a91b63b6120207

Thanks
Wey

