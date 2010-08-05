Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0HEABb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:01:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49318 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0HEAB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1008032149410.20393@ask.diku.dk>
References: <Pine.LNX.4.64.1008032149410.20393@ask.diku.dk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 4 Aug 2010 18:01:08 -0600
X-Google-Sender-Auth: omcyfhG92R2LFMj2qxtNkSe4w7s
Message-ID: <AANLkTi=4WimRKyPWv=ZckXBC4vsgnUPFgWu6EkfZN_zO@mail.gmail.com>
Subject: Re: [PATCH] arch/powerpc: Drop unnecessary of_node_put
To: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 1:50 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> for_each_node_by_name only exits when its first argument is NULL, and a
> subsequent call to of_node_put on that argument is unnecessary.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> iterator name for_each_node_by_name;
> expression np,E;
> identifier l;
> @@
>
> for_each_node_by_name(np,...) {
>  ... when != break;
>      when != goto l;
> }
> ... when != np = E
> - of_node_put(np);
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Looks correct to me:

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

>
> ---
>  arch/powerpc/platforms/powermac/feature.c |    1 -
>  arch/powerpc/platforms/powermac/pci.c     |    2 --
>  2 files changed, 3 deletions(-)
>
> diff -u -p a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
> --- a/arch/powerpc/platforms/powermac/feature.c
> +++ b/arch/powerpc/platforms/powermac/feature.c
> @@ -2872,7 +2872,6 @@ set_initial_features(void)
>                                core99_airport_enable(np, 0, 0);
>                        }
>                }
> -               of_node_put(np);
>        }
>
>        /* On all machines that support sound PM, switch sound off */
> diff -u -p a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
> --- a/arch/powerpc/platforms/powermac/pci.c
> +++ b/arch/powerpc/platforms/powermac/pci.c
> @@ -1155,13 +1155,11 @@ void __init pmac_pcibios_after_init(void
>                        pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, nd, 0, 0);
>                }
>        }
> -       of_node_put(nd);
>        for_each_node_by_name(nd, "ethernet") {
>                if (nd->parent && of_device_is_compatible(nd, "gmac")
>                    && of_device_is_compatible(nd->parent, "uni-north"))
>                        pmac_call_feature(PMAC_FTR_GMAC_ENABLE, nd, 0, 0);
>        }
> -       of_node_put(nd);
>  }
>
>  void pmac_pci_fixup_cardbus(struct pci_dev* dev)
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
