Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2BRWb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 17:31:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58661 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575Ab2BRWbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 17:31:52 -0500
Message-ID: <1329604310.1753.30.camel@joe2Laptop>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Joe Perches <joe@perches.com>
To: Jorgyano Vieira <jorgyano@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, nsankar@broadcom.com, jarod@wilsonet.com
Date: Sat, 18 Feb 2012 14:31:50 -0800
In-Reply-To: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 20:10 -0200, Jorgyano Vieira wrote:
> Replace the usage of BCMLOG_ERR with pr_err and remove the macro definition.
> Also added pr_fmt to identify the driver error messages.

Hi Jorgyano.

Couple of generic comments.

o Please look for and fix spelling errors at the same time.
o Coalesce formats, don't worry about 80 columns for that.
o pr_fmt needs to be #defined before any #include that might
  directly or indirectly #include kernel.h/printk.h
  use 'strings <path>/built-in.o | grep "^<.>"' to verify. 
o [kv][kzm]alloc failures don't need specific OOM messages
  as the generic function does a dump_stack
o argument alignment could be after the open parenthesis.

for example...

>  	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
>  		if (ctx->user[i].mode == DTS_DIAG_MODE ||
>  		    ctx->user[i].mode == DTS_PLAYBACK_MODE) {
> -			BCMLOG_ERR("multiple playback sessions are not "
> +			pr_err("multiple playback sessions are not "
[]
> @@ -766,7 +767,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
>  	crystalhd_hw_dump_desc(desc, last_desc_ix, 1);
>  
>  	if (count != xfr_sz) {
> -		BCMLOG_ERR("interal error sz curr:%x exp:%x\n", count, xfr_sz);
> +		pr_err("interal error sz curr:%x exp:%x\n", count, xfr_sz);
>  		return BC_STS_ERROR;
>  	}
[]
> @@ -1950,7 +1951,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
>  	for (i = 0; i < BC_RX_LIST_CNT; i++) {
>  		rpkt = kzalloc(sizeof(*rpkt), GFP_KERNEL);
>  		if (!rpkt) {
> -			BCMLOG_ERR("Insufficient Memory For RX\n");
> +			pr_err("Insufficient Memory For RX\n");
>  			crystalhd_hw_free_dma_rings(hw);
>  			return BC_STS_INSUFF_RES;
>  		}
> @@ -1959,7 +1960,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
>  		if (mem) {
>  			memset(mem, 0, mem_len);
>  		} else {
> -			BCMLOG_ERR("Insufficient Memory For RX\n");
> +			pr_err("Insufficient Memory For RX\n");
>  			crystalhd_hw_free_dma_rings(hw);
>  			kfree(rpkt);
>  			return BC_STS_INSUFF_RES;
[]
> @@ -177,7 +177,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
>  		rc = crystalhd_user_data(ua_off, io->add_cdata,
>  					io->add_cdata_sz, 1);
>  		if (rc) {
> -			BCMLOG_ERR("failed to push add_cdata sz:%x ua_off:%x\n",
> +			pr_err("failed to push add_cdata sz:%x ua_off:%x\n",
>  				   io->add_cdata_sz, (unsigned int)ua_off);
>  			return -ENODATA;
>  		}
[]
> @@ -383,7 +383,7 @@ void *bc_kern_dma_alloc(struct crystalhd_adp *adp, uint32_t sz,
>  	void *temp = NULL;
>  
>  	if (!adp || !sz || !phy_addr) {
> -		BCMLOG_ERR("Invalide Arg..\n");
> +		pr_err("%s: Invalide Arg..\n", __func__);
>  		return temp;
>  	}
>  


