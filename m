Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043Ab0CPHdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:33:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33959
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966027Ab0CPHdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:33:49 -0400
Date: Tue, 16 Mar 2010 00:34:10 -0700 (PDT)
Message-Id: <20100316.003410.232587710.davem@davemloft.net>
To: julia@diku.dk
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/sunsab.c: adjust the constant used to
 initialize the interrupt_mask0 fields
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1003121816500.3043@ask.diku.dk>
References: <Pine.LNX.4.64.1003121816500.3043@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Fri, 12 Mar 2010 18:17:13 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> SAB82532_ISR0_TCD is declared in drivers/serial/subsab.h as relating to a
> status register, while SAB82532_IMR0_TCD is declared in the same file as
> relating to a mask register.  The latter seems more appropriate for the
> interrupt_mask0 field, and follows the strategy for initializing this field
> elsewhere in the same file.
> 
> Both SAB82532_ISR0_TCD and SAB82532_IMR0_TCD have the same value.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks Julia.

I'll add some entries to MAINTAINERS so that you know to
CC: sparclinux for these sparc serial drivers in the future.

> 
> ---
>  drivers/serial/sunsab.c             |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
> index d514e28..d2e0321 100644
> --- a/drivers/serial/sunsab.c
> +++ b/drivers/serial/sunsab.c
> @@ -474,7 +474,7 @@ static void sunsab_stop_rx(struct uart_port *port)
>  {
>  	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
>  
> -	up->interrupt_mask0 |= SAB82532_ISR0_TCD;
> +	up->interrupt_mask0 |= SAB82532_IMR0_TCD;
>  	writeb(up->interrupt_mask1, &up->regs->w.imr0);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
