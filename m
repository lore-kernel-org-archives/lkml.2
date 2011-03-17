Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1CQPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:07:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1CQPHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p/Y+wRtoePazmBDHxdk4xCJ4byMuoBdF5TnSjylYDok1GQ8aDnGFB3lp3MzEKD7WQ/
         1LodBUPrc+4qN/Dc3ztWlEbhGKb2KVfBfd8Rs0ZNwiJEgIy63JM99Z2Sg1TtDLqidCXP
         8qpBIZ8jIqFVcjqIvaN4quRJA7S808hJQLwWw=
MIME-Version: 1.0
In-Reply-To: <1299477315.10486.1.camel@mola>
References: <1299477315.10486.1.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 17 Mar 2011 23:07:02 +0800
Message-ID: <AANLkTimvx4xkk=HyO_nv+zOiWrZhtgWvAzzjuxYin8Uy@mail.gmail.com>
Subject: Re: [PATCH 1/2] [ARM] am200epd: fix resource leak in
 am200_init_gpio_regs error path
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

On Mon, Mar 7, 2011 at 1:55 PM, Axel Lin <axel.lin@gmail.com> wrote:
> If gpio_request fails when i > 0, gpios[0] is not freed in current
> implementation.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-pxa/am200epd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
> index 3499fad..811d797 100644
> --- a/arch/arm/mach-pxa/am200epd.c
> +++ b/arch/arm/mach-pxa/am200epd.c
> @@ -128,8 +128,8 @@ static int am200_init_gpio_regs(struct metronomefb_par *par)
>        return 0;
>
>  err_req_gpio:
> -       while (i > 0)
> -               gpio_free(gpios[i--]);
> +       while (--i >= 0)
> +               gpio_free(gpios[i]);
>
>        return err;
>  }
> --
> 1.7.2
>
>
>
>
