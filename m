Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AXPlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:41:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1AXPlv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 24 Jan 2011 10:41:51 -0500
Date: Mon, 24 Jan 2011 10:39:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>, Jan Beulich <JBeulich@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pcifront: don't use flush_scheduled_work()
Message-ID: <20110124153958.GA1222@dumpdata.com>
References: <20110124144303.GG11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124144303.GG11404@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 03:43:03PM +0100, Tejun Heo wrote:
> flush_scheduled_work() is scheduled for deprecation.  Cancel ->op_work

2.6.39 or 2.6.40? Not seeing it referenced in feature-removal-schedule.txt file?

> directly instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ryan Wilson <hap9@epoch.ncsc.mil>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jan Beulich <JBeulich@novell.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/xen-pcifront.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: work/drivers/pci/xen-pcifront.c
> ===================================================================
> --- work.orig/drivers/pci/xen-pcifront.c
> +++ work/drivers/pci/xen-pcifront.c
> @@ -733,8 +733,7 @@ static void free_pdev(struct pcifront_de
>  
>  	pcifront_free_roots(pdev);
>  
> -	/*For PCIE_AER error handling job*/

Any reason for getting rid of the comment?

> -	flush_scheduled_work();
> +	cancel_work_sync(&pdev->op_work);
>  
>  	if (pdev->irq >= 0)
>  		unbind_from_irqhandler(pdev->irq, pdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
