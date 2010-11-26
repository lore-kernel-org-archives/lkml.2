Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0KZKCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:02:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:34906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0KZKC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:02:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="861568070"
Date: Fri, 26 Nov 2010 11:02:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/39] drivers/mfd: Update WARN uses
Message-ID: <20101126100225.GA5520@sortiz-mobl>
References: <cover.1288471897.git.joe@perches.com>
 <726f9189d4f8427f23b4e5ae98879012f7a88dea.1288471898.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <726f9189d4f8427f23b4e5ae98879012f7a88dea.1288471898.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sat, Oct 30, 2010 at 02:08:32PM -0700, Joe Perches wrote:
> Remove KERN_<level>.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.


> ---
>  drivers/mfd/ezx-pcap.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index c2b698d..4f674275 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -199,8 +199,7 @@ static void pcap_isr_work(struct work_struct *work)
>  			if (service & 1) {
>  				struct irq_desc *desc = irq_to_desc(irq);
>  
> -				if (WARN(!desc, KERN_WARNING
> -						"Invalid PCAP IRQ %d\n", irq))
> +				if (WARN(!desc, "Invalid PCAP IRQ %d\n", irq))
>  					break;
>  
>  				if (desc->status & IRQ_DISABLED)
> @@ -282,7 +281,7 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
>  	mutex_lock(&pcap->adc_mutex);
>  	req = pcap->adc_queue[pcap->adc_head];
>  
> -	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
> +	if (WARN(!req, "adc irq without pending request\n")) {
>  		mutex_unlock(&pcap->adc_mutex);
>  		return IRQ_HANDLED;
>  	}
> -- 
> 1.7.3.1.g432b3.dirty
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
