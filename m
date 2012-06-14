Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2FNLE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:04:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46404 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab2FNLEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:04:55 -0400
Date: Thu, 14 Jun 2012 14:04:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] staging/xgifb: Cleanup vb_device_info struct
Message-ID: <20120614110418.GX13539@mwanda>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
 <1339626112-20671-14-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339626112-20671-14-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:21:52AM +0200, Peter Huewe wrote:
> @@ -1565,15 +1548,15 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
>  		/* Not DDR */
>  		xgifb_reg_set(pVBInfo->P3c4,
>  			      0x31,
> -			      (*pVBInfo->pSR31 & 0x3F) | 0x40);
> +			      (XGI330_SR31 & 0x3F) | 0x40);

You didn't introduce this, but Smatch complains about this and I
was wondering what was going on.  XGI330_SR31 is 0xc0 and
(0xc0 & 0x3F) is zero.  Probably the plan was to make XGI330_SR31
configurable?

regards,
dan carpenter

>  		xgifb_reg_set(pVBInfo->P3c4,
>  			      0x32,
> -			      (*pVBInfo->pSR32 & 0xFC) | 0x01);
> +			      (XGI330_SR32 & 0xFC) | 0x01);
>  	} else {
> -		xgifb_reg_set(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
> -		xgifb_reg_set(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
> +		xgifb_reg_set(pVBInfo->P3c4, 0x31, XGI330_SR31);
> +		xgifb_reg_set(pVBInfo->P3c4, 0x32, XGI330_SR32);
>  	}
> -	xgifb_reg_set(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
> +	xgifb_reg_set(pVBInfo->P3c4, 0x33, XGI330_SR33);
>  	printk("17");
>  
>  	/*

