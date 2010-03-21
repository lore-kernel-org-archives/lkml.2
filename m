Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0CUJPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 05:15:11 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:58791 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0CUJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 05:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=u1/+qtr5dAb3bFprMfe3aY2uIocxIah1dBd0Cm3GIyTJM53gDSOLzrI29z4AJAaBCI
         Da/lYNGAV7sp/CDCrx3wgaiR7a/XBCeTdZ9skBwzx1+gTWI7c1GHiMUC/DS2NqfVjMyd
         Y/8kpjsF4P3NqQtzG6GA+XoFhVsTnGUdbLTZ8=
Date: Sun, 21 Mar 2010 12:14:55 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       harvey.harrison@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: reg.c Coding style fixes.
Message-ID: <20100321091455.GH5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker> <4BA5204C.9050208@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA5204C.9050208@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 08:21:48PM +0100, Lars Lindley wrote:
> 
> 
> On 2010-03-20 17:24, Dan Carpenter wrote:
> > On Sat, Mar 20, 2010 at 04:14:11PM +0100, Lars Lindley wrote:
> >> I fixed all problems reported by checkpatch.pl except some
> >> (a lot of) long lines and some printk:s.
> >> I removed "commented away" code and version comments.
> >>
> > 
> > 	[snip]
> > 
> >> -		msleep(10); // Modify 20051221.1.b
> >> -		Wb35Reg_WriteSync( pHwData, 0x03d4, 0xb8 );// REG_ON RF_RSTN on, and
> >> -		msleep(10); // Modify 20051221.1.b
> > 
> > 	You removed this msleep().
> > 
> 
> Oops! I think I was fooled by the strange comment on the line before..
> 
> >> -
> >> +	if (pHwData->phy_type <= RF_MAXIM_V1)
> >> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xffffff38);
> >> +	else {
> >> +		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
> >> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
> >> +		msleep(10);
> >> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and msleep(10); */
> > 
> > In the new version it's commented out.                                             ^^^^^^^^^^^^
> > 
> > I used a program to try verify that only white space changed.
> > http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/01012.html
> > 
> > Then when it failed I grovelled through to find what changed.
> > 
> > Actually my tool complained about removed parenthesis as well.  I think 
> > this patch only removes one set of parenthesis.  Please don't do that.  
> > With a patch this size, it's nice to be able to use tools to verify that 
> > it doesn't change anything, instead of checking it by hand. Tabs, spaces
> > and newlines only, please.
> > 
> Point taken. Will keep it in mind from now on..
> 
> > Obviously in the next patch you can send the one liner that remove the
> > parenthesis.  We can eyeball one liners quite quickly.
> > 
> > regards,
> > dan carpenter
> > 
> 
> 
> Here's a patch to fix my screw up :)
> Now the .o doesn't differ before and after..
> 

Could you post your config?  I would think the curly brace change would
have made a difference even if all the line number changes didn't.

regards,
dan carpenter

> 
> [PATCH] staging: winbond: reg.c Fix accidental commenting of msleep(10)
> 
> I accidentaly commented out msleep() in one place.
> This applies after previous patch:
> Message-Id: <1269098051-6594-1-git-send-email-lindley@coyote.org>
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/reg.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
> index 2bddf8f..d9a8128 100644
> --- a/drivers/staging/winbond/reg.c
> +++ b/drivers/staging/winbond/reg.c
> @@ -890,7 +890,8 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
>  		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
>  		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
>  		msleep(10);
> -		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and msleep(10); */
> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and */
> +		msleep(10);
>  		ltmp = 0x4968;
>  		if ((pHwData->phy_type == RF_WB_242) ||
>  			(RF_WB_242_1 == pHwData->phy_type))
> -- 
> 1.7.0.2
