Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1ECRnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:43:04 -0400
Received: from kroah.org ([198.145.64.141]:33817 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1ECRnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:43:02 -0400
Date: Tue, 3 May 2011 10:42:54 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503174254.GA6545@kroah.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503163128.24853.15446.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503163128.24853.15446.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 05:31:49PM +0100, Alan Cox wrote:
> From: Vinod Koul <vinod.koul@intel.com>
> 
> During suspend and runtime_suspend audio dsp will be in D3 state
> and will loose its context.
> 
> This patch adds support in driver to save the dsp context
> and restore this context during resume
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Something is messed up here as:

> --- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
> +++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
> @@ -508,6 +508,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
>  			sst_drv_ctx->pmic_state = SND_MAD_INIT_DONE;
>  			sst_drv_ctx->rx_time_slot_status = 0; /*default AMIC*/
>  			card->pcm_control = sst_pmic_ops.pcm_control;
> +			sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
>  			return 0;
>  		} else {
>  			pr_err("strcmp fail %s\n", card->module_name);

This line is in the original patch from Vinod in this function that
added the driver to the tree (git commit id fffa1cca), so the patch
doesn't apply at all.  Do you see this too?

If I comment out this chunk, the patch fails later on as well:

patching file drivers/staging/intel_sst/intelmid.c
Hunk #1 FAILED at 805.
1 out of 1 hunk FAILED -- saving rejects to file drivers/staging/intel_sst/intelmid.c.rej


Which is odd.

What tree did you generate this series against?  I don't have any
outstanding sst patches in my "to-apply" queue, did I miss some that you
previously sent that I should have applied first?

confused,

greg k-h
