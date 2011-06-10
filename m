Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1FJOq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:46:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64768 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1FJOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:46:57 -0400
Date: Fri, 10 Jun 2011 08:46:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: basic_mmio: add missing include of spinlock_types.h
Message-ID: <20110610144655.GA26900@ponder.secretlab.ca>
References: <1307709889-31350-1-git-send-email-jamie@jamieiles.com>
 <20110610124805.GN3711@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610124805.GN3711@pulham.picochip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:48:05PM +0100, Jamie Iles wrote:
> On Fri, Jun 10, 2011 at 01:44:49PM +0100, Jamie Iles wrote:
> > include/linux/basic_mmio_gpio.h uses a spinlock_t without including any
> > of the spinlock headers resulting in this compiler warning.
> > 
> > include/linux/basic_mmio_gpio.h:51:2: error: expected specifier-qualifier-list before 'spinlock_t'
> > 
> > Explicitly include linux/spinlock_types.h to fix it.
> 
> Sorry, wrong patch.  Here's the correct one.
> 
> Jamie

Applied, thanks.

g.

> 
> 8<---
> 
> From cd6afb281b31596c175ea3ee1d44f0efea25250f Mon Sep 17 00:00:00 2001
> From: Jamie Iles <jamie@jamieiles.com>
> Date: Fri, 10 Jun 2011 13:41:44 +0100
> Subject: [PATCH] gpio: basic_mmio: add missing include of spinlock_types.h
> 
> include/linux/basic_mmio_gpio.h uses a spinlock_t without including any
> of the spinlock headers resulting in this compiler warning.
> 
> include/linux/basic_mmio_gpio.h:51:2: error: expected specifier-qualifier-list before 'spinlock_t'
> 
> Explicitly include linux/spinlock_types.h to fix it.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  include/linux/basic_mmio_gpio.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
> index 1ae1271..98999cf 100644
> --- a/include/linux/basic_mmio_gpio.h
> +++ b/include/linux/basic_mmio_gpio.h
> @@ -16,6 +16,7 @@
>  #include <linux/gpio.h>
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <linux/spinlock_types.h>
>  
>  struct bgpio_pdata {
>  	int base;
> -- 
> 1.7.4.1
> 
