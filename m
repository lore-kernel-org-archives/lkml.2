Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab1LEP1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:27:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44260 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932314Ab1LEP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:27:18 -0500
Date: Mon, 5 Dec 2011 15:27:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        arnd@arndb.de, eric.miao@linaro.org, sameo@linux.intel.com
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v8
Message-ID: <20111205152715.GT11150@opensource.wolfsonmicro.com>
References: <1320152142.4892.4.camel@L-0761.kpit.com>
 <1323067584.1652.10.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323067584.1652.10.camel@L-0761.kpit.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 12:16:24PM +0530, ashishj3 wrote:

> --- a/drivers/base/regmap/regmap-irq.c
> +++ b/drivers/base/regmap/regmap-irq.c
> @@ -164,7 +164,6 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
>   * irq:       The IRQ the device uses to signal interrupts
>   * irq_flags: The IRQF_ flags to use for the primary interrupt.
>   * chip:      Configuration for the interrupt controller.
> - * data:      Runtime data structure for the controller, allocated on success

Uh, that's not good...

> -	irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
> -	if (irq_base < 0) {
> +	*irq_base = irq_alloc_descs(*irq_base, 0, chip->num_irqs, 0);
> +	if (*irq_base < 0) {

This isn't adding an accessory, this is passing irq_base by reference.
Seems like a lot of pointers, really.  I'll send a patch.
