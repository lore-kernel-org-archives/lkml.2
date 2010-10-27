Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab0J0KCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:02:51 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:57051 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab0J0KCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:02:49 -0400
Message-ID: <4CC7F876.9090106@ge.com>
Date: Wed, 27 Oct 2010 11:01:26 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 07/30] staging/vme/tsi148: remove double freeing of the
 IRQ in .remove
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-8-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-8-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 10:02:43.0506 (UTC) FILETIME=[19125920:01CB75BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> tsi148_irq_exit is called twice in .remove, which causes an oops.
> 
> Remove the second call, which apart from being redundant cannot
> possibly work; the CR/CSR space has been already unmapped.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_tsi148.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 660968e..acfbd59 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2612,8 +2612,6 @@ static void tsi148_remove(struct pci_dev *pdev)
>  		kfree(master_image);
>  	}
>  
> -	tsi148_irq_exit(bridge, pdev);
> -
>  	iounmap(bridge->base);
>  
>  	pci_release_regions(pdev);


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
