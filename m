Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1HAM3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:29:36 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:55595 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HAM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:29:30 -0400
Message-ID: <4E369C26.5040300@ge.com>
Date: Mon, 01 Aug 2011 13:29:26 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] staging: vme: rename *_slot_get to *_get_slot
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2011 12:26:21.0338 (UTC) FILETIME=[3889A7A0:01CC5046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 11:20, Manohar Vanga wrote:
> Functions following the naming format of *_get and *_put are used
> for reference counting. Rename the slot_get functions to get_slot
> to prevent such confusion in the meaning.
> 

If your doing vme_slot_get, then there's also vme_lm_get, vme_master_get and
vme_slave_get.

Doing just this would then lead to more inconsistency in the naming and
wouldn't even get rid of all the functions using the *_get naming convention.

I'm not sure this change is worth it.

Martyn

> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    8 ++++----
>  drivers/staging/vme/bridges/vme_tsi148.c   |    6 +++---
>  drivers/staging/vme/vme.c                  |   12 ++++++------
>  drivers/staging/vme/vme.h                  |    2 +-
>  drivers/staging/vme/vme_api.txt            |    2 +-
>  drivers/staging/vme/vme_bridge.h           |    2 +-
>  6 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 2f9c22b..dff64e1 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -1490,7 +1490,7 @@ static int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
>  	return 0;
>  }
>  
> -static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
> +static int ca91cx42_get_slot(struct vme_bridge *ca91cx42_bridge)
>  {
>  	u32 slot = 0;
>  	struct ca91cx42_driver *bridge;
> @@ -1551,7 +1551,7 @@ static int ca91cx42_crcsr_init(struct vme_bridge *ca91cx42_bridge,
>  
>  	bridge = ca91cx42_bridge->driver_priv;
>  
> -	slot = ca91cx42_slot_get(ca91cx42_bridge);
> +	slot = ca91cx42_get_slot(ca91cx42_bridge);
>  
>  	/* Write CSR Base Address if slot ID is supplied as a module param */
>  	if (geoid)
> @@ -1799,7 +1799,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	ca91cx42_bridge->lm_get = ca91cx42_lm_get;
>  	ca91cx42_bridge->lm_attach = ca91cx42_lm_attach;
>  	ca91cx42_bridge->lm_detach = ca91cx42_lm_detach;
> -	ca91cx42_bridge->slot_get = ca91cx42_slot_get;
> +	ca91cx42_bridge->get_slot = ca91cx42_get_slot;
>  	ca91cx42_bridge->alloc_consistent = ca91cx42_alloc_consistent;
>  	ca91cx42_bridge->free_consistent = ca91cx42_free_consistent;
>  
> @@ -1807,7 +1807,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	dev_info(&pdev->dev, "Board is%s the VME system controller\n",
>  		(data & CA91CX42_MISC_CTL_SYSCON) ? "" : " not");
>  	dev_info(&pdev->dev, "Slot ID is %d\n",
> -		ca91cx42_slot_get(ca91cx42_bridge));
> +		ca91cx42_get_slot(ca91cx42_bridge));
>  
>  	if (ca91cx42_crcsr_init(ca91cx42_bridge, pdev))
>  		dev_err(&pdev->dev, "CR/CSR configuration failed.\n");
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 9db89dc..922902b 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2106,7 +2106,7 @@ static int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
>  /*
>   * Determine Geographical Addressing
>   */
> -static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
> +static int tsi148_get_slot(struct vme_bridge *tsi148_bridge)
>  {
>  	u32 slot = 0;
>  	struct tsi148_driver *bridge;
> @@ -2191,7 +2191,7 @@ static int tsi148_crcsr_init(struct vme_bridge *tsi148_bridge,
>  	cbar = ioread32be(bridge->base + TSI148_CBAR);
>  	cbar = (cbar & TSI148_CRCSR_CBAR_M)>>3;
>  
> -	vstat = tsi148_slot_get(tsi148_bridge);
> +	vstat = tsi148_get_slot(tsi148_bridge);
>  
>  	if (cbar != vstat) {
>  		cbar = vstat;
> @@ -2474,7 +2474,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	tsi148_bridge->lm_get = tsi148_lm_get;

>  	tsi148_bridge->lm_attach = tsi148_lm_attach;
>  	tsi148_bridge->lm_detach = tsi148_lm_detach;
> -	tsi148_bridge->slot_get = tsi148_slot_get;
> +	tsi148_bridge->get_slot = tsi148_get_slot;
>  	tsi148_bridge->alloc_consistent = tsi148_alloc_consistent;
>  	tsi148_bridge->free_consistent = tsi148_free_consistent;
>  
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 759ec2b..81a33dc 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1332,7 +1332,7 @@ void vme_lm_free(struct vme_resource *resource)
>  }
>  EXPORT_SYMBOL(vme_lm_free);
>  
> -int vme_slot_get(struct device *bus)
> +int vme_get_slot(struct device *bus)
>  {
>  	struct vme_bridge *bridge;
>  
> @@ -1342,14 +1342,14 @@ int vme_slot_get(struct device *bus)
>  		return -EINVAL;
>  	}
>  
> -	if (bridge->slot_get == NULL) {
> -		printk(KERN_WARNING "vme_slot_get not supported\n");
> +	if (bridge->get_slot == NULL) {
> +		printk(KERN_WARNING "vme_get_slot not supported\n");
>  		return -EINVAL;
>  	}
>  
> -	return bridge->slot_get(bridge);
> +	return bridge->get_slot(bridge);
>  }
> -EXPORT_SYMBOL(vme_slot_get);
> +EXPORT_SYMBOL(vme_get_slot);
>  
>  
>  /* - Bridge Registration --------------------------------------------------- */
> @@ -1549,7 +1549,7 @@ static int vme_bus_match(struct device *dev, struct device_driver *drv)
>  				return 1;
>  
>  			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
> -				(num == vme_slot_get(dev)))
> +				(num == vme_get_slot(dev)))
>  				return 1;
>  		}
>  		i++;
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 8fb35e2..bda6fdf 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -162,7 +162,7 @@ int vme_lm_attach(struct vme_resource *, int, void (*callback)(int));
>  int vme_lm_detach(struct vme_resource *, int);
>  void vme_lm_free(struct vme_resource *);
>  
> -int vme_slot_get(struct device *);
> +int vme_get_slot(struct device *);
>  
>  int vme_register_driver(struct vme_driver *);
>  void vme_unregister_driver(struct vme_driver *);
> diff --git a/drivers/staging/vme/vme_api.txt b/drivers/staging/vme/vme_api.txt
> index 4910e92..e0152c5 100644
> --- a/drivers/staging/vme/vme_api.txt
> +++ b/drivers/staging/vme/vme_api.txt
> @@ -380,4 +380,4 @@ Slot Detection
>  
>  This function returns the slot ID of the provided bridge.
>  
> -	int vme_slot_get(struct device *dev);
> +	int vme_get_slot(struct device *dev);
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index ef751a4..5f70848 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -164,7 +164,7 @@ struct vme_bridge {
>  	int (*lm_detach) (struct vme_lm_resource *, int);
>  
>  	/* CR/CSR space functions */
> -	int (*slot_get) (struct vme_bridge *);
> +	int (*get_slot) (struct vme_bridge *);
>  
>  	/* Bridge parent interface */
>  	void *(*alloc_consistent)(struct device *dev, size_t size,


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
