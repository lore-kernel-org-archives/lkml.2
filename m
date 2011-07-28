Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1G1KHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:07:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52121 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1G1KHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:07:02 -0400
Date: Thu, 28 Jul 2011 11:06:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] arch: arm: mach-cns3xxx: Add external interrupt
	pin demo program
Message-ID: <20110728100648.GD31473@n2100.arm.linux.org.uk>
References: <1311873475-26111-1-git-send-email-tommy.lin.1101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311873475-26111-1-git-send-email-tommy.lin.1101@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 01:17:55AM +0800, Tommy Lin wrote:
> +#include <mach/gpio.h>

Need I mention it...
> +static irqreturn_t cns3xxx_ext_intr1_handler(int irq, void *dev_id)
> +{
> +	int value;
> +
> +	value = gpio_get_value(led_D6);
> +
> +	disable_irq_nosync(irq);
> +
> +	gpio_set_value(led_D6, !value);
> +
> +	enable_irq(irq);

Why do you need the disable_irq/enable_irq ?  The interrupt you're
dealing with will already be masked by the core genirq code.
