Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1HSR7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:59:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61769 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HSR7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <1313760467-8598-67-git-send-email-ian.campbell@citrix.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
	<1313760467-8598-67-git-send-email-ian.campbell@citrix.com>
Date: Fri, 19 Aug 2011 18:59:53 +0100
Message-ID: <CANK3SE2zOO2TwiF=vSrGRB=D6=MZdwMywe2mTkUBn56XJdPXfg@mail.gmail.com>
Subject: Re: [PATCH 67/75] et131x: convert to SKB paged frag API.
From: Mark Einon <mark.einon@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2011 14:27, Ian Campbell <ian.campbell@citrix.com> wrote:
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Mark Einon <mark.einon@gmail.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/et131x/et1310_tx.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

Just a heads up - This patch is going to create some merge issues
if/when the outstanding changes I've sent for inclusion in the staging
tree get merged back.
Should be fairly trivial to fix though.

Cheers,
Mark

>
> diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
> index 8fb3051..03e7a4e 100644
> --- a/drivers/staging/et131x/et1310_tx.c
> +++ b/drivers/staging/et131x/et1310_tx.c
> @@ -519,12 +519,12 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
>                         * returned by pci_map_page() is always 32-bit
>                         * addressable (as defined by the pci/dma subsystem)
>                         */
> -                       desc[frag++].addr_lo =
> -                           pci_map_page(etdev->pdev,
> -                                        frags[i - 1].page,
> -                                        frags[i - 1].page_offset,
> -                                        frags[i - 1].size,
> -                                        PCI_DMA_TODEVICE);
> +                       desc[frag++].addr_lo = skb_frag_dma_map(
> +                                                       &etdev->pdev->dev,
> +                                                       &frags[i - 1],
> +                                                       0,
> +                                                       frags[i - 1].size,
> +                                                       PCI_DMA_TODEVICE);
>                }
>        }
>
> --
> 1.7.2.5
>
>
