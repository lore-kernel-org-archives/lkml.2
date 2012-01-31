Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2AaDZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:25:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:5191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2AaDZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:25:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="61503578"
Subject: Re: [PATCH v2 3/5] drivers/dma/amba-pl08x.c: adjust double test
From: Vinod Koul <vinod.koul@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1326404970-1084-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1326404970-1084-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 08:56:39 +0530
Message-ID: <1327980399.1527.54.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 22:49 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Rewrite a duplicated test to test the correct value
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E;
> @@
> 
> (
> * E
>   || ... || E
> |
> * E
>   && ... && E
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> There is a dstbus field, so it is my guess that that should be tested
> instead of testing the srcbus field again.
> 
>  drivers/dma/amba-pl08x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 8a28158..840c6c0 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -649,7 +649,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  			}
>  
>  			if ((bd.srcbus.addr % bd.srcbus.buswidth) ||
> -					(bd.srcbus.addr % bd.srcbus.buswidth)) {
> +					(bd.dstbus.addr % bd.dstbus.buswidth)) {
>  				dev_err(&pl08x->adev->dev,
>  					"%s src & dst address must be aligned to src"
>  					" & dst width if peripheral is flow controller",
> 
Applied thanks

-- 
~Vinod

