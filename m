Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2KUIek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:34:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2KUIej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:34:39 -0500
Date: Wed, 21 Nov 2012 11:34:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: wlags49_h2: ap_h2.c: fixes inconsistent
 spacing around *
Message-ID: <20121121083417.GD11248@mwanda>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
 <1353422700-14485-7-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353422700-14485-7-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:45:00PM +0200, Johan Meiring wrote:
> This commit fixes an inconsistent spacing issue around *
> 

The others are good, but this one is not right.

> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
> ---
>  drivers/staging/wlags49_h2/ap_h2.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wlags49_h2/ap_h2.c b/drivers/staging/wlags49_h2/ap_h2.c
> index e524153..c2d43ec 100644
> --- a/drivers/staging/wlags49_h2/ap_h2.c
> +++ b/drivers/staging/wlags49_h2/ap_h2.c
> @@ -3256,7 +3256,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
>  		0x0146,		/* sizeof(fw_image_1_data), */
>  		0x00000060,					/* Target address in NIC Memory */
>  		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
> -		(hcf_8 FAR *) fw_image_1_data
> +		(hcf_8 FAR*) fw_image_1_data

We don't use far pointers in linux.  When you're casting something
there is no space between the cat operation and the variable.  The
reason is that casting is a high precedence operation.

More readable:  (char *)p + 1;
Less readable:  (char *) p + 1;

In the first line it's obvious that we cast first and then add 1.

So this should be:
	(hcf_8 *)fw_image_1_data,

regards,
dan carpenter

