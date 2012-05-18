Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab2ERABi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:01:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48782 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552Ab2ERABf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:01:35 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio-mcp23s08: dbg_show: fix pullup configuration display
To: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
In-Reply-To: <1335347513-5831-1-git-send-email-jacmet@sunsite.dk>
References: <1335347513-5831-1-git-send-email-jacmet@sunsite.dk>
Date: Thu, 17 May 2012 18:01:33 -0600
Message-Id: <20120518000133.C2EA43E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 11:51:53 +0200, Peter Korsgaard <jacmet@sunsite.dk> wrote:
> Pullups are enabled when bits are set, not when cleared.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-mcp23s08.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index c5d83a8..0f42518 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -353,7 +353,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  			chip->base + t, bank, t, label,
>  			(mcp->cache[MCP_IODIR] & mask) ? "in " : "out",
>  			(mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
> -			(mcp->cache[MCP_GPPU] & mask) ? "  " : "up");
> +			(mcp->cache[MCP_GPPU] & mask) ? "up" : "  ");
>  		/* NOTE:  ignoring the irq-related registers */
>  		seq_printf(s, "\n");
>  	}
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
