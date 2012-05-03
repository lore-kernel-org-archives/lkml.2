Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2ECPhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:37:00 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:59474 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2ECPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:36:58 -0400
Message-ID: <4FA2A611.7040106@ge.com>
Date: Thu, 03 May 2012 16:36:49 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: Re: [PATCH] vme: vme_ca91cx42.c: local functions should not be exposed
 globally
References: <201205021712.22325.hartleys@visionengravers.com>
In-Reply-To: <201205021712.22325.hartleys@visionengravers.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2012 15:36:52.0709 (UTC) FILETIME=[902D7150:01CD2942]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/12 01:12, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warnings:
> 
> warning: symbol 'ca91cx42_alloc_consistent' was not declared. Should it be static?
> warning: symbol 'ca91cx42_free_consistent' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Martyn Welch <martyn.welch@ge.com>

Good catch,

Acked-by: Martyn Welch <martyn.welch@ge.com>

Martyn

> 
> ---
> 
> diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
> index a3c0f84..e0df92e 100644
> --- a/drivers/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/vme/bridges/vme_ca91cx42.c
> @@ -1501,7 +1501,7 @@ static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
>  
>  }
>  
> -void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
> +static void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
>  	dma_addr_t *dma)
>  {
>  	struct pci_dev *pdev;
> @@ -1512,8 +1512,8 @@ void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
>  	return pci_alloc_consistent(pdev, size, dma);
>  }
>  
> -void ca91cx42_free_consistent(struct device *parent, size_t size, void *vaddr,
> -	dma_addr_t dma)
> +static void ca91cx42_free_consistent(struct device *parent, size_t size,
> +	void *vaddr, dma_addr_t dma)
>  {
>  	struct pci_dev *pdev;
>  


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
