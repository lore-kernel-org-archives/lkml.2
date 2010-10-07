Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab0JGIWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 04:22:37 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:41718 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0JGIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 04:22:35 -0400
Message-ID: <19629.33589.158235.949280@ipc1.ka-ro>
Date: Thu, 7 Oct 2010 10:22:13 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: <Dinh.Nguyen@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de, bryan.wu@canonical.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4] ARM: imx: Add iram allocator functions
In-Reply-To: <1286383682-26506-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1286383682-26506-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
> +void __iomem*iram_alloc(unsigned int size, unsigned long *dma_addr)
> +{
> +	if (!iram_pool)
> +		return NULL;
> +
> +	*dma_addr = gen_pool_alloc(iram_pool, size);
> +	pr_debug("iram alloc - %dB@0x%p\n", size, (void *)*dma_addr);
why not:
| +	pr_debug("iram alloc - %dB@0x08lx\n", size, *dma_addr);

> +	if (!dma_addr)
>
This will never be true (unless someone passes a NULL pointer as
dma_addr).
| +	if (!*dma_addr)
was obviously meant here.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
