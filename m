Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2LKNIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:08:25 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:6192 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab2LKNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:08:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,259,1355094000"; 
   d="scan'208";a="165457331"
Date: Tue, 11 Dec 2012 14:08:16 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/pinctrl/pinctrl-at91.c: convert kfree to
 devm_kfree
In-Reply-To: <50C72E75.8030706@mvista.com>
Message-ID: <alpine.DEB.2.02.1212111407570.2091@hadrien>
References: <1355223525-19165-1-git-send-email-Julia.Lawall@lip6.fr> <50C72E75.8030706@mvista.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, Sergei Shtylyov wrote:

> Hello.
>
> On 11-12-2012 14:58, Julia Lawall wrote:
>
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> > The function at91_dt_node_to_map is ultimately called by the function
> > pinctrl_get, which is an exported function.  Since it is possible that this
> > function is not called from within a probe function, for safety, the kfree
> > is converted to a devm_kfree, to both free the data and remove it from the
> > device in a failure situation.
>
> > A newline is added in the call to devm_kfree to avoid exceeding the 80
>
>    devm_kzalloc() you mean?

Yes, sorry.  Should I send a new patch?

thanks,
julia

> > character limit.
>
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> > ---
> >   drivers/pinctrl/pinctrl-at91.c |    5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> > index c5e7571..0da8a5f 100644
> > --- a/drivers/pinctrl/pinctrl-at91.c
> > +++ b/drivers/pinctrl/pinctrl-at91.c
> > @@ -255,7 +255,8 @@ static int at91_dt_node_to_map(struct pinctrl_dev
> > *pctldev,
> >   	}
> >
> >   	map_num += grp->npins;
> > -	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
> > GFP_KERNEL);
> > +	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
> > +			       GFP_KERNEL);
>
> WBR, Sergei
>
>
>
