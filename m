Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2KGRIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:08:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33524 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2KGRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:08:12 -0500
Message-ID: <509A9579.5090002@wwwdotorg.org>
Date: Wed, 07 Nov 2012 10:08:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: tegra: create irq mapping in gpio_to_irq
References: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 08:01 AM, Laxman Dewangan wrote:
> The gpio interrupts get mapped linearly and hence the mapping
> of irq need to be created by irq_create_mapping().
> 
> The function gpio_to_irq() returns the irq by irq_find_mapping()
> and so returns 0 as there is no mapping created. Fix the function
> to create mapping when gpio_to_irq() get called.

I'm not convinced this should be needed. tegra_gpio_probe() contains:

>         for (gpio = 0; gpio < tegra_gpio_chip.ngpio; gpio++) {
>                 int irq = irq_create_mapping(irq_domain, gpio);

which should create the mapping for every IRQ.

(although I do think the gpiochip_add() should be moved to the very end
of probe(), I doubt that impacts this issue much)
