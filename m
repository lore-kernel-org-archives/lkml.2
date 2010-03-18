Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0CRRNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:13:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34760 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0CRRNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:13:07 -0400
Message-ID: <4BA2540D.4090203@cs.helsinki.fi>
Date: Thu, 18 Mar 2010 18:25:49 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c: converted long if-else to switch
References: <1268779048-21397-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268779048-21397-1-git-send-email-lindley@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> I converted the long if-else in function Mds_HeaderCopy() to a switch
> instead. It compiles fine but i don't have the hardware to test.
> Please check that I didn't do anything bad to it..
> The patch applies on top of this patch:
> Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/mds.c |   38 +++++++++++++++++++++++---------------
>  1 files changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
> index ef08b51..6082fa8 100644
> --- a/drivers/staging/winbond/mds.c
> +++ b/drivers/staging/winbond/mds.c
> @@ -400,30 +400,38 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter,
>  							       * back rate
>  							       */
>  
> -		if (ctmp1 == 108)
> +		switch (ctmp1) {
> +		case 108:
>  			ctmp2 = 7;
> -		else if (ctmp1 == 96)
> +			break;
> +		case 96:
>  			ctmp2 = 6;	/* Rate convert for USB */
> -		else if (ctmp1 == 72)
> +			break;
> +		case 72:
>  			ctmp2 = 5;
> -		else if (ctmp1 == 48)
> +			break;
> +		case 48:
>  			ctmp2 = 4;
> -		else if (ctmp1 == 36)
> +			break;
> +		case 36:
> +		case 22:
>  			ctmp2 = 3;
> -		else if (ctmp1 == 24)
> +			break;
> +		case 24:
> +		case 11:
>  			ctmp2 = 2;
> -		else if (ctmp1 == 18)
> +			break;
> +		case 18:
> +		case 4:
>  			ctmp2 = 1;
> -		else if (ctmp1 == 12)
> +			break;
> +		case 12:
>  			ctmp2 = 0;
> -		else if (ctmp1 == 22)
> -			ctmp2 = 3;
> -		else if (ctmp1 == 11)
> -			ctmp2 = 2;
> -		else if (ctmp1 == 4)
> -			ctmp2 = 1;
> -		else
> +			break;
> +		default:
>  			ctmp2 = 0;	/* if (ctmp1 == 2) or default */
> +			break;
> +		}

Reordering the checks makes the patch harder to review but yeah, looks 
good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka
