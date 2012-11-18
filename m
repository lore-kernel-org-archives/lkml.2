Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2KRXo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 18:44:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:10342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab2KRXoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 18:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="244081842"
Date: Mon, 19 Nov 2012 00:44:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/6] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20121118234450.GB18738@sortiz-mobl>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349320509-26930-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thu, Oct 04, 2012 at 12:15:04AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> On a mx53qsb dt-kernel the da9052-core driver fails to probe as follows:
> 
> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> 
> The reason for the error was due to passing only the offset as the interrupt
> number in request_threaded_irq() without da9052->irq_base.
> 
> The recommended approach though is to use regmap_get_virq() to acquire the
> interrupt number and this allows to get rid of da9052->irq_base.
> 
> Fix it and allow the driver to probe successfully.
> 
> Also provide a few more error logs and change the irq string to "adc-irq", so
> that it appears as a single word in 'cat /proc/interrupts'
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/da9052-core.c |   34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
This patch and the next 5 ones are now applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
