Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0DBJyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:54:43 -0400
Received: from mga06.intel.com ([134.134.136.21]:51324 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753484Ab0DBJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="505804406"
Date: Fri, 2 Apr 2010 11:55:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <error27@gmail.com>, Paul Fertser <fercerpav@gmail.com>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arnaud Patard <arnaud.patard@rtp-net.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd: off by one issue
Message-ID: <20100402095511.GA8010@sortiz.org>
References: <20100328112808.GO5069@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328112808.GO5069@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sun, Mar 28, 2010 at 02:28:08PM +0300, Dan Carpenter wrote:
> "pcf->irq_handler" has PCF50633_NUM_IRQ elements.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Patch applied, many thanks.

Cheers,
Samuel.


> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 03dcc92..4f13608 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -217,7 +217,7 @@ static struct attribute_group pcf_attr_group = {
>  int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
>  			void (*handler) (int, void *), void *data)
>  {
> -	if (irq < 0 || irq > PCF50633_NUM_IRQ || !handler)
> +	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
>  		return -EINVAL;
>  
>  	if (WARN_ON(pcf->irq_handler[irq].handler))
> @@ -234,7 +234,7 @@ EXPORT_SYMBOL_GPL(pcf50633_register_irq);
>  
>  int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
>  {
> -	if (irq < 0 || irq > PCF50633_NUM_IRQ)
> +	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
>  		return -EINVAL;
>  
>  	mutex_lock(&pcf->lock);

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
