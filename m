Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2GYIP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:15:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:13336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab2GYIPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:15:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="177208130"
Date: Wed, 25 Jul 2012 16:15:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] avr32: fix build error in ATSTK1002 code
Message-ID: <20120725081521.GA18328@localhost>
References: <20120722022541.GA8279@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722022541.GA8279@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, will you accept this fix? It's obviously caused by a typo in
commit 1754aab9bb86.

On Sun, Jul 22, 2012 at 10:25:41AM +0800, Fengguang Wu wrote:
> arch/avr32/boards/atstk1000/atstk1002.c:100: error: 'num_partitions' undeclared here (not in a function)
> 
> which is introduced by commit 1754aab9bb86 ("mtd: ATMEL, AVR32: inline
> nand partition table access ").
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  arch/avr32/boards/atstk1000/atstk1002.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
> index dc52633..6c80aba 100644
> --- a/arch/avr32/boards/atstk1000/atstk1002.c
> +++ b/arch/avr32/boards/atstk1000/atstk1002.c
> @@ -97,7 +97,7 @@ static struct atmel_nand_data atstk1006_nand_data __initdata = {
>  	.enable_pin	= GPIO_PIN_PB(29),
>  	.ecc_mode	= NAND_ECC_SOFT,
>  	.parts		= nand_partitions,
> -	.num_parts	= ARRAY_SIZE(num_partitions),
> +	.num_parts	= ARRAY_SIZE(nand_partitions),
>  };
>  #endif
>  
> -- 
> 1.7.10
> 
