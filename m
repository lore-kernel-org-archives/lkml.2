Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0KZRi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:38:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43855 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753594Ab0KZRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:38:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18p0iB4kMcpNkxCGGitomo692LWkFP2TSKxTwFyft
	MRWnySN88QDaD7
Date: Fri, 26 Nov 2010 18:38:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vasiliy Kulikov <segoon@openwall.com>
cc: kernel-janitors@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Magnus Damm <damm@opensource.se>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: boards: mach-se: use IS_ERR() instead of NULL check
In-Reply-To: <1290791190-21358-1-git-send-email-segoon@openwall.com>
Message-ID: <Pine.LNX.4.64.1011261835500.16655@axis700.grange>
References: <1290791190-21358-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Vasiliy Kulikov wrote:

> clk_get() returns ERR_PTR() on error, not NULL.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Yep, there are, probably, a couple more of these, similar to

http://marc.info/?t=128715350900002&r=1&w=2

Hardly required, but if you like:

Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  Cannot compile this driver, so it is not tested at all.
> 
>  arch/sh/boards/mach-se/7724/setup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
> index c31d228..6735305 100644
> --- a/arch/sh/boards/mach-se/7724/setup.c
> +++ b/arch/sh/boards/mach-se/7724/setup.c
> @@ -871,14 +871,14 @@ static int __init devices_setup(void)
>  
>  	/* set SPU2 clock to 83.4 MHz */
>  	clk = clk_get(NULL, "spu_clk");
> -	if (clk) {
> +	if (!IS_ERR(clk)) {
>  		clk_set_rate(clk, clk_round_rate(clk, 83333333));
>  		clk_put(clk);
>  	}
>  
>  	/* change parent of FSI A */
>  	clk = clk_get(NULL, "fsia_clk");
> -	if (clk) {
> +	if (!IS_ERR(clk)) {
>  		clk_register(&fsimcka_clk);
>  		clk_set_parent(clk, &fsimcka_clk);
>  		clk_set_rate(clk, 11000);
> -- 
> 1.7.0.4
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
