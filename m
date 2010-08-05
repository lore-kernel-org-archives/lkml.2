Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389Ab0HEVKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:10:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58421 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab0HEVKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XdTqT1OABUsQZ1FDI3SD2XNkqLxgatjY8EsPisdU4fbskxwYkYMmYluT3eQJbeGi3t
         erEBg2bVzdvo3X1/rEXZpS5kOxC8uRwl5sJrJGWQvYNT61rgWcGKRCoccWWaZFF+oOLd
         GdS/xAsnt9FXYv+13mrwAqaMoYTMvYzstZovs=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1008052219010.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052219010.31692@ask.diku.dk>
Date: Thu, 5 Aug 2010 14:10:46 -0700
X-Google-Sender-Auth: ZyYjWOogHwdbe7p8CxLqtQF7sa4
Message-ID: <AANLkTim49t=xgQeFLeFaQGqKvr1MXt67nck+uiH-V62X@mail.gmail.com>
Subject: Re: [PATCH 8/42] drivers/net/ixgbe: Adjust confusing if indentation
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 13:19, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Both ifs and assignments to autoc seem similar enough that they are both
> put in the if branch indicated by their indentation.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
>
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
>
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
>
> if (p1[0].column == p2[0].column):
>  cocci.print_main("branch",p1)
>  cocci.print_secs("after",p2)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
> This changes the semantics and might be the wrong fix.  Not tested.
>
>  drivers/net/ixgbe/ixgbe_82599.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ixgbe/ixgbe_82599.c b/drivers/net/ixgbe/ixgbe_82599.c
> index 3e06a61..a5fcdce 100644
> --- a/drivers/net/ixgbe/ixgbe_82599.c
> +++ b/drivers/net/ixgbe/ixgbe_82599.c
> @@ -766,12 +766,13 @@ s32 ixgbe_setup_mac_link_82599(struct ixgbe_hw *hw,
>            link_mode == IXGBE_AUTOC_LMS_KX4_KX_KR_SGMII) {
>                /* Set KX4/KX/KR support according to speed requested */
>                autoc &= ~(IXGBE_AUTOC_KX4_KX_SUPP_MASK | IXGBE_AUTOC_KR_SUPP);
> -               if (speed & IXGBE_LINK_SPEED_10GB_FULL)
> +               if (speed & IXGBE_LINK_SPEED_10GB_FULL) {
>                        if (orig_autoc & IXGBE_AUTOC_KX4_SUPP)
>                                autoc |= IXGBE_AUTOC_KX4_SUPP;
>                        if ((orig_autoc & IXGBE_AUTOC_KR_SUPP) &&
>                            (hw->phy.smart_speed_active == false))
>                                autoc |= IXGBE_AUTOC_KR_SUPP;
> +               }
>                if (speed & IXGBE_LINK_SPEED_1GB_FULL)
>                        autoc |= IXGBE_AUTOC_KX_SUPP;
>        } else if ((pma_pmd_1g == IXGBE_AUTOC_1G_SFI) &&

Thanks Julia, I ave added the path to my queue.

-- 
Cheers,
Jeff
