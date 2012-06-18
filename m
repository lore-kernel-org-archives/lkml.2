Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2FRKUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:20:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57714 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2FRKUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:20:21 -0400
Date: Mon, 18 Jun 2012 11:20:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
Message-ID: <20120618102003.GB12029@n2100.arm.linux.org.uk>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-9-git-send-email-lee.jones@linaro.org> <20120614183231.GA30185@sirena.org.uk> <4FDEEEBD.5070108@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDEEEBD.5070108@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 10:02:53AM +0100, Lee Jones wrote:
> @@ -361,7 +362,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
>  static void ab8500_irq_mask(struct irq_data *data)
>  {
>  	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
> -	int offset = data->irq - ab8500->irq_base;
> +	int offset = data->irq;

Are you sure this is right?  I thought irq_data->irq was the Linux IRQ
number, irq_data->hwirq was the interrupt number inside the domain.
