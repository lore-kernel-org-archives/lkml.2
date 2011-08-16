Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1HPTRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:17:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:44470 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1HPTRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:17:08 -0400
Subject: Re: [PATCH] pci/of: Don't crash when bridge parent is NULL.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Daney <david.daney@cavium.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <1313519077-18457-1-git-send-email-david.daney@cavium.com>
References: <1313519077-18457-1-git-send-email-david.daney@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 14:16:18 -0500
Message-ID: <1313522178.3664.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 11:24 -0700, David Daney wrote:
> In pcibios_get_phb_of_node(), we will crash while booting if
> bus->bridge->parent is NULL.
> 
> Check for this case and avoid dereferencing the NULL pointer.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Jesse or Grant, I'm travelling, can any of you send that to Linus asap ?

Cheers,
Ben.

> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/pci/of.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> index c94d37e..f092993 100644
> --- a/drivers/pci/of.c
> +++ b/drivers/pci/of.c
> @@ -55,7 +55,7 @@ struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
>  	 */
>  	if (bus->bridge->of_node)
>  		return of_node_get(bus->bridge->of_node);
> -	if (bus->bridge->parent->of_node)
> +	if (bus->bridge->parent && bus->bridge->parent->of_node)
>  		return of_node_get(bus->bridge->parent->of_node);
>  	return NULL;
>  }


