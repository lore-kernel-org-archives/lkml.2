Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1JJGPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:15:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43416 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1JJGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:15:35 -0400
Date: Mon, 10 Oct 2011 09:12:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rts_pstor:Fix SDIO issue
Message-ID: <20111010061238.GX18470@longonot.mountain>
References: <1318211504-22108-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318211504-22108-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E928D81.0024:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:51:44AM +0800, wei_wang@realsil.com.cn wrote:
> @@ -3157,17 +3158,16 @@ int reset_sd_card(struct rtsx_chip *chip)
>  				if (retval != STATUS_SUCCESS) {
>  					TRACE_RET(chip, STATUS_FAIL);
>  				}
> +				retval = STATUS_FAIL;
>  			}
>  
> -			if (!chip->sd_io) {
> +			if (!chip->sd_io)
>  				retval = reset_mmc(chip);
> -			}

+ 			if (retval != STATUS_SUCCESS) 
+				TRACE_RET(chip, STATUS_FAIL);

>  		}
>  	}
>  
> -	if (retval != STATUS_SUCCESS) {
> +	if (retval != STATUS_SUCCESS)
>  		TRACE_RET(chip, STATUS_FAIL);
> -	}

Then you can remove this check.  It's better to have the checks for
failure as soon after the function call as possible.

>  
>  	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
>  	if (retval != STATUS_SUCCESS) {

regards,
dan carpenter
