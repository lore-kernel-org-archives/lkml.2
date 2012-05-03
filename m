Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab2ECPzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:55:43 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:47894 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab2ECPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:55:41 -0400
Message-ID: <4FA2AA6E.6030400@ge.com>
Date: Thu, 03 May 2012 16:55:26 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten lin <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: Re: [PATCH] vme: vme_tsi148.c: local functions should not be exposed
 globally
References: <201205021708.38406.hartleys@visionengravers.com>
In-Reply-To: <201205021708.38406.hartleys@visionengravers.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2012 15:55:30.0172 (UTC) FILETIME=[2A3CC3C0:01CD2945]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/12 01:08, H Hartley Sweeten lin wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warnings:
> 
> warning: symbol 'tsi148_alloc_consistent' was not declared. Should it be static?
> warning: symbol 'tsi148_free_consistent' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Martyn Welch <martyn.welch@ge.com>
> 

Good catch,

Acked-by: Martyn Welch <martyn.welch@ge.com>

Martyn

> ---
> 
> diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
> index 081e9c4..f6385f7 100644
> --- a/drivers/vme/bridges/vme_tsi148.c
> +++ b/drivers/vme/bridges/vme_tsi148.c
> @@ -2141,7 +2141,7 @@ static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
>  	return (int)slot;
>  }
>  
> -void *tsi148_alloc_consistent(struct device *parent, size_t size,
> +static void *tsi148_alloc_consistent(struct device *parent, size_t size,
>  	dma_addr_t *dma)
>  {
>  	struct pci_dev *pdev;
> @@ -2152,8 +2152,8 @@ void *tsi148_alloc_consistent(struct device *parent, size_t size,
>  	return pci_alloc_consistent(pdev, size, dma);
>  }
>  
> -void tsi148_free_consistent(struct device *parent, size_t size, void *vaddr,
> -	dma_addr_t dma)
> +static void tsi148_free_consistent(struct device *parent, size_t size,
> +	void *vaddr, dma_addr_t dma)
>  {
>  	struct pci_dev *pdev;
>  


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
