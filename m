Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2FRPFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:05:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18628 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2FRPFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:05:16 -0400
Date: Mon, 18 Jun 2012 18:04:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] Staging: xgifb: Remove XGIFAIL() macro and its calls.
Message-ID: <20120618150434.GL4400@mwanda>
References: <cover.1340016625.git.magomez@igalia.com>
 <7d6346bfccd6b00f7718b8d4ec9a8543871cf580.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d6346bfccd6b00f7718b8d4ec9a8543871cf580.1340016625.git.magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:12:03PM +0200, Miguel Gómez wrote:
> --- a/drivers/staging/xgifb/XGI_main_26.c
> +++ b/drivers/staging/xgifb/XGI_main_26.c
> @@ -1376,8 +1376,10 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>  		vtotal = var->upper_margin + var->yres + var->lower_margin
>  				+ var->vsync_len;
>  
> -	if (!(htotal) || !(vtotal))
> -		XGIFAIL("XGIfb: no valid timing data");
> +	if (!(htotal) || !(vtotal)) {

Don't resend this, but next time feel free to write this like:

	if (!htotal || !vtotal) {

We do have a one change per patch rule but tiny formatting things
like that don't count as a change.

regards,
dan carpenter

> +		pr_debug("XGIfb: no valid timing data\n");
> +		return -EINVAL;
> +	}
>  
>  	if (var->pixclock && htotal && vtotal) {
>  		drate = 1000000000 / var->pixclock;

