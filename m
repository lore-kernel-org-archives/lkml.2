Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0J0JxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:53:11 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:60216 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0J0JxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:53:08 -0400
Message-ID: <4CC7F635.6090005@ge.com>
Date: Wed, 27 Oct 2010 10:51:49 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 06/30] staging/vme/tsi148: use list_for_each_safe when
 deleting resources in .remove
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-7-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-7-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 09:53:06.0827 (UTC) FILETIME=[C1581DB0:01CB75BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> This fixes an oops when removing the module.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_tsi148.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index e341122..660968e 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2532,6 +2532,7 @@ err_struct:
>  static void tsi148_remove(struct pci_dev *pdev)
>  {
>  	struct list_head *pos = NULL;
> +	struct list_head *tmplist;
>  	struct vme_master_resource *master_image;
>  	struct vme_slave_resource *slave_image;
>  	struct vme_dma_resource *dma_ctrlr;
> @@ -2590,21 +2591,21 @@ static void tsi148_remove(struct pci_dev *pdev)
>  	tsi148_crcsr_exit(tsi148_bridge, pdev);
>  
>  	/* resources are stored in link list */
> -	list_for_each(pos, &tsi148_bridge->dma_resources) {
> +	list_for_each_safe(pos, tmplist, &tsi148_bridge->dma_resources) {
>  		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
>  		list_del(pos);
>  		kfree(dma_ctrlr);
>  	}
>  
>  	/* resources are stored in link list */
> -	list_for_each(pos, &tsi148_bridge->slave_resources) {
> +	list_for_each_safe(pos, tmplist, &tsi148_bridge->slave_resources) {
>  		slave_image = list_entry(pos, struct vme_slave_resource, list);
>  		list_del(pos);
>  		kfree(slave_image);
>  	}
>  
>  	/* resources are stored in link list */
> -	list_for_each(pos, &tsi148_bridge->master_resources) {
> +	list_for_each_safe(pos, tmplist, &tsi148_bridge->master_resources) {
>  		master_image = list_entry(pos, struct vme_master_resource,
>  			list);
>  		list_del(pos);


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
