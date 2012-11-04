Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2KDKIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:08:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2KDKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:08:29 -0500
Date: Sun, 4 Nov 2012 10:08:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6 v2] arm: use devicetree to get smp_twd clock
Message-ID: <20121104100822.GY21164@n2100.arm.linux.org.uk>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com> <1351882309-733-2-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351882309-733-2-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 01:51:44PM -0500, Mark Langsdorf wrote:
> -static struct clk *twd_get_clock(void)
> +static struct clk *twd_get_clock(struct device_node *np)
>  {
> -	struct clk *clk;
> +	struct clk *clk = NULL;
>  	int err;
>  
> -	clk = clk_get_sys("smp_twd", NULL);
> +	if (np)
> +		clk = of_clk_get(np, 0);
> +	if (!clk)

What does a NULL return from of_clk_get() mean?  Where is this defined?

> @@ -349,6 +348,10 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>  	if (!twd_base)
>  		return -ENOMEM;
>  
> +	twd_clk = twd_get_clock(NULL);
> +
> +	twd_clk = twd_get_clock(NULL);
> +

Why twice?
