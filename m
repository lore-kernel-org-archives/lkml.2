Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0IPV7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:59:21 -0400
Received: from fifo99.com ([67.223.236.141]:49749 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab0IPV7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:59:18 -0400
Subject: Re: FW: next build fails
From: Daniel Walker <dwalker@fifo99.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100917075242.e0bc4b54.sfr@canb.auug.org.au>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
	 <20100916164442.df749cc1.sfr@canb.auug.org.au>
	 <1284656407.2411.5.camel@c-dwalke-linux.qualcomm.com>
	 <20100917075242.e0bc4b54.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 14:58:57 -0700
Message-ID: <1284674337.2411.53.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 07:52 +1000, Stephen Rothwell wrote:

> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index 820f6ba..fc8828b 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -334,10 +334,16 @@ cpu_elf_name:
>  __v7_ca9mp_proc_info:
>  	.long	0x410fc090		@ Required ID value
>  	.long	0xff0ffff0		@ Mask for ID
> -	.long   PMD_TYPE_SECT | \
> +	ALT_SMP(.long \
> +		PMD_TYPE_SECT | \
>  		PMD_SECT_AP_WRITE | \
>  		PMD_SECT_AP_READ | \
> -		PMD_FLAGS
> +		PMD_FLAGS_SMP)
> +	ALT_UP(.long \
> +		PMD_TYPE_SECT | \
> +		PMD_SECT_AP_WRITE | \
> +		PMD_SECT_AP_READ | \
> +		PMD_FLAGS_UP)

Yeah, exactly .. This is what I did to update my patch .. Do you want to
include this, or should I update my version and my tree.. Ultimately my
version has to go into Russell's tree..

Daniel

