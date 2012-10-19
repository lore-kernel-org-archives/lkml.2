Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab2JSQWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:22:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34597 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab2JSQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:22:30 -0400
Message-ID: <50817E43.8000804@wwwdotorg.org>
Date: Fri, 19 Oct 2012 10:22:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik: use irq_create_mapping()
References: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1350659375-7335-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 09:09 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Since in the DT case, the linear domain path will not allocate
> descriptors for the IRQs, we need to use irq_create_mapping()
> for mapping hwirqs to Linux IRQs, so these descriptors get
> created on-the-fly in this case.

> @@ -931,7 +931,7 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
>  	while (status) {
>  		int bit = __ffs(status);
>  
> -		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
> +		generic_handle_irq(irq_create_mapping(nmk_chip->domain, bit));

Surely this one can remain as irq_find_mapping() since isn't
nmk_gpio_to_irq() guaranteed to have been called first for this GPIO/IRQ?

