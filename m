Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1G1KFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:05:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52112 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab1G1KFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:05:01 -0400
Date: Thu, 28 Jul 2011 11:04:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arch: arm: mach-cns3xxx: Add gpiolib support
Message-ID: <20110728100444.GC31473@n2100.arm.linux.org.uk>
References: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 01:16:41AM +0800, Tommy Lin wrote:
> +#include <linux/platform_device.h>
> +#include <linux/proc_fs.h>
> +#include <linux/io.h>
> +
> +#include <mach/gpio.h>

Come on guys, you absolutely deserve your code to break as you're
continuing to include mach/gpio.h directly, even after I've said
I'm going to be moving stuff out of mach/gpio.h into asm/gpio.h...

> +#include <asm-generic/gpio.h>
> +
> +#define gpio_get_value				__gpio_get_value
> +#define gpio_set_value				__gpio_set_value
> +#define gpio_cansleep				__gpio_cansleep
> +#define gpio_to_irq				__gpio_to_irq

Oh look, yet another identical implementation to add to the list...
(it's this stuff which I'm moving after this merge window.)

Please, make sure you include linux/gpio.h and not mach/gpio.h.
