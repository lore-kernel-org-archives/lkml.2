Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0IHANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:13:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52613 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0IHANQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b6bjJNullW1RPe04SSMBlXhpq2jIU1xFHqaFb14crWtTfvzQE5V2CyK3+0Uy346CCo
         l1D/2BFN2brkRYalCYmSuYVA2L+Haa+1ay+tpqf11JOpzEmrX+XsDLRpqF3pzUVm27pm
         ZVLO/xzMq2SB9ekRAIXpNlB7nf9raVpS6Amkc=
MIME-Version: 1.0
In-Reply-To: <20100907.163331.260082741.davem@davemloft.net>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
	<20100907.163331.260082741.davem@davemloft.net>
Date: Tue, 7 Sep 2010 17:13:14 -0700
Message-ID: <AANLkTin6RcDPFWpG4YBRF4O-8nrsA6e77K=knBA-uyf9@mail.gmail.com>
Subject: Re: Is via-velocity broken in 2.6.34?
From: Matt Causey <matt.causey@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 4:33 PM, David Miller <davem@davemloft.net> wrote:
>
> Please always CC: netdev@vger.kernel.org for networking reports.
>
> Give this patch a try:
>
> --------------------
> via-velocity: Turn scatter-gather support back off.
>
> It causes all kinds of DMA API debugging assertions and
> all straight-forward attempts to fix it have failed.
>
> So turn off SG, and we'll tackle making this work
> properly in net-next-2.6
>
> Reported-by: Dave Jones <davej@redhat.com>
> Tested-by: Dave Jones <davej@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/via-velocity.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
> index fd69095..f534123 100644
> --- a/drivers/net/via-velocity.c
> +++ b/drivers/net/via-velocity.c
> @@ -2824,7 +2824,7 @@ static int __devinit velocity_found1(struct pci_dev *pdev, const struct pci_devi
>        netif_napi_add(dev, &vptr->napi, velocity_poll, VELOCITY_NAPI_WEIGHT);
>
>        dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_FILTER |
> -               NETIF_F_HW_VLAN_RX | NETIF_F_IP_CSUM | NETIF_F_SG;
> +               NETIF_F_HW_VLAN_RX | NETIF_F_IP_CSUM;
>
>        ret = register_netdev(dev);
>        if (ret < 0)

So before I posted to the list, I actually dug through looking for
recent changes which would be trivial for me to back out.  This was
the only one I had found, so I tried it.  :-)  No luck though...same
result.

Thanks,

--
Matt
