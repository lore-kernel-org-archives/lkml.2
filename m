Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0INTgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:36:24 -0400
Received: from complete.lackof.org ([198.49.126.79]:34587 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0INTgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:36:23 -0400
Date: Tue, 14 Sep 2010 13:36:10 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] drivers/net/tulip/de4x5.c: prevent reading
	uninitialized stack memory
Message-ID: <20100914193610.GB24373@lackof.org>
References: <AANLkTiki4bNP83B2WEPcKnnDqHibxqYyi6V2CjiG9GEO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiki4bNP83B2WEPcKnnDqHibxqYyi6V2CjiG9GEO@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 07:46:38PM -0400, Dan Rosenberg wrote:
> The DE4X5_GET_REG device ioctl allows unprivileged users to read 32
> bytes of uninitialized stack memory, because it copies the
> uninitialized "addr" member instead of the intended "lval" member.
> This patch takes care of it.

Dan, Good catch.

Dave, please apply.

> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> 
> --- linux-2.6.35.4.orig/drivers/net/tulip/de4x5.c	2010-09-11
> 19:12:27.000000000 -0400
> +++ linux-2.6.35.4/drivers/net/tulip/de4x5.c	2010-09-11 19:17:12.000000000 -0400
> @@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
>  	tmp.lval[6] = inl(DE4X5_STRR); j+=4;
>  	tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
>  	ioc->len = j;
> -	if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
> +	if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
>  	break;
> 
>  #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */
