Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1K0CZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:25:50 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44058 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab1K0CZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:25:46 -0500
Date: Sun, 27 Nov 2011 03:25:43 +0100
From: Micha <mirq-linux@rere.qmqm.pl>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Viresh Kumar <viresh.kumar@st.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: convert drivers/mmc/host/* to use
 module_platform_driver()
Message-ID: <20111127022543.GA30300@rere.qmqm.pl>
References: <1322283343.14278.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322283343.14278.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 12:55:43PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/mmc/host/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
[...]
> --- a/drivers/mmc/host/cb710-mmc.c
> +++ b/drivers/mmc/host/cb710-mmc.c
> @@ -780,18 +780,7 @@ static struct platform_driver cb710_mmc_driver = {
>  #endif
>  };
>  
> -static int __init cb710_mmc_init_module(void)
> -{
> -	return platform_driver_register(&cb710_mmc_driver);
> -}
> -
> -static void __exit cb710_mmc_cleanup_module(void)
> -{
> -	platform_driver_unregister(&cb710_mmc_driver);
> -}
> -
> -module_init(cb710_mmc_init_module);
> -module_exit(cb710_mmc_cleanup_module);
> +module_platform_driver(cb710_mmc_driver);

No functional change, so:

[for cb710]
Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
