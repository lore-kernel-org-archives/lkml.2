Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2GTNpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:45:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5846 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GTNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:45:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 20 Jul 2012 06:44:43 -0700
Date: Fri, 20 Jul 2012 16:44:41 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: fix return value check in clk_get
Message-ID: <20120720134441.GD9437@tbergstrom-lnx.Nvidia.com>
References: <1342791397-11732-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342791397-11732-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:36:37PM +0200, Peter De Schrijver wrote:
> of_clk_get_by_name returns an ERR_PTR on failure. Hence we should use IS_ERR()
> and not just check for a non NULL value.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/clkdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 8f87b0f..d423c9b 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -157,7 +157,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>  
>  	if (dev) {
>  		clk = of_clk_get_by_name(dev->of_node, con_id);
> -		if (clk && __clk_get(clk))
> +		if (!IS_ERR(clk) && __clk_get(clk))
>  			return clk;
>  	}

http://www.spinics.net/lists/arm-kernel/msg184794.html introduces this
behaviour of of_clk_get_by_name()

Cheers,

Peter.

