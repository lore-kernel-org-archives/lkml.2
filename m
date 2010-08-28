Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0H1Qux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:50:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53897 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0H1Quv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tFdOxv44zJr/YtPCvD02SXFZzwAik2/o+Ceu00IYSTYXfExsYh39JJhAXUs9rcsrxk
         rx9MU/Z+RtCjt3xUn0ldptkvQZClAZsDY8yFg0Hy+xhfk+EA5xQs9nL6/Juf311yLxdH
         EYw0PTwRGr3p2UzKXMkemvGnM+kiqPH01XlSc=
Date: Sat, 28 Aug 2010 18:50:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jie.Yang@atheros.com,
        lrodriguez@atheros.com
Subject: Re: [PATCH 3/7] drivers/net/atl1c: Remove double test
Message-ID: <20100828165014.GJ9832@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jie.Yang@atheros.com, lrodriguez@atheros.com
References: <1283010066-20935-1-git-send-email-julia@diku.dk> <1283010066-20935-4-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283010066-20935-4-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added the Atheros people to the CC list.  Jie Yang should know.

regards,
dan carpenter

On Sat, Aug 28, 2010 at 05:41:02PM +0200, Julia Lawall wrote:
> The nic_type field is compared to athr_l2c twice.
> 
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @expression@
> expression E;
> @@
> 
> (
> * E
>   || ... || E
> |
> * E
>   && ... && E
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This is a guess as to what the code should be.  Perhaps something else
> should have been tested instead.
> 
>  drivers/net/atl1c/atl1c_hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/atl1c/atl1c_hw.c b/drivers/net/atl1c/atl1c_hw.c
> index d8501f0..919080b 100644
> --- a/drivers/net/atl1c/atl1c_hw.c
> +++ b/drivers/net/atl1c/atl1c_hw.c
> @@ -480,7 +480,7 @@ int atl1c_phy_reset(struct atl1c_hw *hw)
>  		atl1c_write_phy_reg(hw, MII_DBG_DATA, 0x929D);
>  	}
>  	if (hw->nic_type == athr_l1c || hw->nic_type == athr_l2c_b2
> -		|| hw->nic_type == athr_l2c || hw->nic_type == athr_l2c) {
> +		|| hw->nic_type == athr_l2c) {
>  		atl1c_write_phy_reg(hw, MII_DBG_ADDR, 0x29);
>  		atl1c_write_phy_reg(hw, MII_DBG_DATA, 0xB6DD);
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
