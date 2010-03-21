Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0CUUDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:03:06 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38310 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752456Ab0CUUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:03:04 -0400
Date: Sun, 21 Mar 2010 21:02:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c: converted long if-else to
 switch
Message-ID: <20100321200255.GA1933@elf.ucw.cz>
References: <1268779048-21397-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268779048-21397-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-16 23:37:28, Lars Lindley wrote:
> I converted the long if-else in function Mds_HeaderCopy() to a switch
> instead. It compiles fine but i don't have the hardware to test.
> Please check that I didn't do anything bad to it..
> The patch applies on top of this patch:
> Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

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
>  
>  		if (i == 0)
>  			pT01->T01_transmit_rate = ctmp2;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
