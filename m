Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab2LIOWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 09:22:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:4885 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab2LIOWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 09:22:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="231305213"
Date: Sun, 9 Dec 2012 15:22:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps80031: MFD_TPS80031 needs to select REGMAP_IRQ
Message-ID: <20121209142209.GB26699@sortiz-mobl>
References: <1354713588.14255.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354713588.14255.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Dec 05, 2012 at 09:19:48PM +0800, Axel Lin wrote:
> This driver uses regmap_irq APIs, thus need to select REGMAP_IRQ.
> IRQ_DOMAIN will be selected if select REGMAP_IRQ, thus remove it here.
> 
> This fixes below build errors:
> 
> drivers/built-in.o: In function `tps80031_remove':
> drivers/mfd/tps80031.c:534: undefined reference to `regmap_del_irq_chip'
> drivers/built-in.o: In function `tps80031_irq_init':
> drivers/mfd/tps80031.c:305: undefined reference to `regmap_add_irq_chip'
> drivers/built-in.o: In function `tps80031_probe':
> drivers/mfd/tps80031.c:496: undefined reference to `regmap_irq_get_domain'
> drivers/mfd/tps80031.c:512: undefined reference to `regmap_del_irq_chip'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
