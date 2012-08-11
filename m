Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2HKJNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 05:13:18 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51842 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2HKJNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 05:13:15 -0400
Date: Sat, 11 Aug 2012 11:12:55 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 1/6] ARM: dove: unify clock setup
Message-ID: <20120811091255.GA31809@lunn.ch>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1344255815-4457-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344255815-4457-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian

> -static void __init clk_init(void)
> +static void __init dove_clk_init(void)
>  {
>  	tclk = clk_register_fixed_rate(NULL, "tclk", NULL, CLK_IS_ROOT,
> -				       get_tclk());
> +				       dove_tclk);
>  
>  	orion_clkdev_init(tclk);
> +
> +	/* Ensure tclk is always clocked */
> +	clk_prepare_enable(tclk);
>  }

"ticking" would be better than clocked. 

Since this is a root fixed clock, is it necessary to prepare_enable()
it? I think prepare and enable become NOPs in this situation.

    Andrew
