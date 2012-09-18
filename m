Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab2IRHnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:43:10 -0400
Received: from linux-sh.org ([111.68.239.195]:40783 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2IRHnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:43:07 -0400
Date: Tue, 18 Sep 2012 16:42:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Message-ID: <20120918074244.GO13568@linux-sh.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34:29PM +0200, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> This patch is a bit ugly for shmobile, which is the only platform
> that just uses integer literals all over the place, but I can't
> see a better way to do this.
> 
If you want to crap up the ARM side with this stuff, that's fine, but
leave sh-sci out of it.

So, NAK on this part:

> diff --git a/include/linux/serial_sci.h b/include/linux/serial_sci.h
> index eb763ad..d323290 100644
> --- a/include/linux/serial_sci.h
> +++ b/include/linux/serial_sci.h
> @@ -150,7 +150,7 @@ struct plat_sci_port {
>  	int		overrun_bit;
>  	unsigned int	error_mask;
>  
> -	int		port_reg;
> +	void __iomem   *port_reg;
>  	unsigned char	regshift;
>  	unsigned char	regtype;
>  
but I don't mind if you cast the callsite in drivers/tty/serial/sh-sci.c
