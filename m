Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394Ab2KAWU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:20:27 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:45494 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2KAWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:20:25 -0400
Date: Thu, 1 Nov 2012 23:20:10 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: plat-versatile: move FPGA irq driver to
 drivers/irqchip
Message-ID: <20121101232010.78269291@skate>
In-Reply-To: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org>
References: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Thu,  1 Nov 2012 22:28:49 +0100, Linus Walleij wrote:

> +void fpga_handle_irq(struct pt_regs *regs);

This function does not need to be exposed in a public header: as
proposed for the bcm2835 and armada-370-xp IRQ controller drivers, the
driver should directly do handle_arch_irq = fpga_handle_irq, and
therefore there is no need for the machine desc structure to reference
fpga_handle_irq anymore.

> +void fpga_irq_init(void __iomem *, const char *, int, int, u32,
> +		struct device_node *node);
> +int fpga_irq_of_init(struct device_node *node,
> +		     struct device_node *parent);

I don't think this function needs to be exported. Just move the
compatible string to drivers/irqchip/irqchip.c and instead of calling
of_irq_init(), call irqchip_init().

This will leave only the fpga_irq_init() function, which we could get
rid of once the non-DT support is removed.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
