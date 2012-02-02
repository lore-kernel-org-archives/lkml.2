Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2BBQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:05:13 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:22933 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261Ab2BBQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:05:11 -0500
X-IronPort-AV: E=Sophos;i="4.71,609,1320620400"; 
   d="scan'208";a="142595755"
Date: Thu, 2 Feb 2012 17:05:02 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: D A <runezcape@gmail.com>
cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] drivers/net/ethernet/ti: Move call to PTR_ERR
 after reassignment
In-Reply-To: <CABPrwzf0hH+2OOFQ2Q6ZVHwn=Ws3SvxbwVn0LwKjfkYVdP8zgg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1202021702500.1928@localhost6.localdomain6>
References: <1328194382-32465-1-git-send-email-Julia.Lawall@lip6.fr> <1328194382-32465-3-git-send-email-Julia.Lawall@lip6.fr> <CABPrwzf0hH+2OOFQ2Q6ZVHwn=Ws3SvxbwVn0LwKjfkYVdP8zgg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-508108714-1328198703=:1928"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-508108714-1328198703=:1928
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 2 Feb 2012, D A wrote:

> hello all,
> 
> im in the janitors for a while now and i keep looking at the emails you keep
> sending to eachother, but i m lost, i have a back ground in C how can i be
> part of this, any body can give some help to start, a small task that i can
> begin with ?

There are hundreds of places where the various devm_ functions, eg 
devm_kzalloc, could be used.  Proceed slowly and carefully...

Documentation/driver-model/devres.txt

julia


> 
> there must be a way or a strategy to absorb new members, i m 3 months now or
> more.
> 
> 
> On Thu, Feb 2, 2012 at 4:53 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>       From: Julia Lawall <Julia.Lawall@lip6.fr>
>
>       PTR_ERR should be called before its argument is cleared.
>
>       The semantic match that finds this problem is as follows:
>       (http://coccinelle.lip6.fr/)
>
>       // <smpl>
>       @@
>       expression e,e1;
>       constant c;
>       @@
>
>       *e = c
>       ... when != e = e1
>          when != &e
>          when != true IS_ERR(e)
>       *PTR_ERR(e)
>       // </smpl>
>
>       Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>       Reported-by: Josh Triplett <josh@joshtriplett.org>
>
>       ---
>       v2: correct commit message.
>
>        drivers/net/ethernet/ti/davinci_emac.c |    3 ++-
>        drivers/net/ethernet/ti/davinci_mdio.c |    2 +-
>        2 files changed, 3 insertions(+), 2 deletions(-)
>
>       diff --git a/drivers/net/ethernet/ti/davinci_emac.c
>       b/drivers/net/ethernet/ti/davinci_emac.c
>       index efd4f3e..922a937 100644
>       --- a/drivers/net/ethernet/ti/davinci_emac.c
>       +++ b/drivers/net/ethernet/ti/davinci_emac.c
>       @@ -1600,8 +1600,9 @@ static int emac_dev_open(struct net_device
>       *ndev)
>                      if (IS_ERR(priv->phydev)) {
>                              dev_err(emac_dev, "could not connect to
>       phy %s\n",
>                                      priv->phy_id);
>       +                       ret = PTR_ERR(priv->phydev);
>                              priv->phydev = NULL;
>       -                       return PTR_ERR(priv->phydev);
>       +                       return ret;
>                      }
>
>                      priv->link = 0;
>       diff --git a/drivers/net/ethernet/ti/davinci_mdio.c
>       b/drivers/net/ethernet/ti/davinci_mdio.c
>       index ef7c9c1..af8b8fc 100644
>       --- a/drivers/net/ethernet/ti/davinci_mdio.c
>       +++ b/drivers/net/ethernet/ti/davinci_mdio.c
>       @@ -318,9 +318,9 @@ static int __devinit
>       davinci_mdio_probe(struct platform_device *pdev)
>
>              data->clk = clk_get(dev, NULL);
>              if (IS_ERR(data->clk)) {
>       -               data->clk = NULL;
>                      dev_err(dev, "failed to get device clock\n");
>                      ret = PTR_ERR(data->clk);
>       +               data->clk = NULL;
>                      goto bail_out;
>              }
> 
>
>       --
>       To unsubscribe from this list: send the line "unsubscribe
>       kernel-janitors" in
>       the body of a message to majordomo@vger.kernel.org
>       More majordomo info at
>        http://vger.kernel.org/majordomo-info.html
> 
> 
> 
>
--8323328-508108714-1328198703=:1928--
