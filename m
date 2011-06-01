Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163107Ab1FAIfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:35:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:5445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163084Ab1FAI1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:17 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH] dma: Initialize uninitialized variable
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1306392516-5906-1-git-send-email-linux@roeck-us.net>
References: <1306392516-5906-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:22:55 +0530
Message-ID: <1306914775.10976.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 23:48 -0700, Guenter Roeck wrote:
> Uninitialized variable results in random debug output.
> Fix by initializing to 0.
> 
> This commit fixes the following warning:
> 
> drivers/dma/pch_dma.c: In function pdc_desc_get:
> drivers/dma/pch_dma.c:406: warning: i may be used uninitialized in this function
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/dma/pch_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
Sorry I seem to have missed this earlier. This fix is already in place

commit 364de77831213be20f7f33c39ca1c194593b5c11
Author: Liu Yuan <tailai.ly@taobao.com>
Date:   Sat Apr 2 14:20:47 2011 +0800

    drivers, pch_dma: Fix uninitialized var before use
    
    In the function pdc_desc_get(), var 'i' is not
    initialized before use. This patch fixes it.
    
    Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

~Vinod

> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 8d8fef1..6eebc62 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -403,7 +403,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
>  {
>  	struct pch_dma_desc *desc, *_d;
>  	struct pch_dma_desc *ret = NULL;
> -	int i;
> +	int i = 0;
>  
>  	spin_lock(&pd_chan->lock);
>  	list_for_each_entry_safe(desc, _d, &pd_chan->free_list, desc_node) {

