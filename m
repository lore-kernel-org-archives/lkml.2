Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab1BVURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:17:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46074 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1BVURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:17:40 -0500
Date: Tue, 22 Feb 2011 21:17:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110222201725.GF22310@pengutronix.de>
References: <1298256658.861611.43913489619.0.gpush@pororo>
 <1298256658.862188.178150188637.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298256658.862188.178150188637.1.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Mon, Feb 21, 2011 at 10:50:58AM +0800, Jeremy Kerr wrote:
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..604be74 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -11,18 +12,168 @@
> ...
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
> ...
> +#else /* !CONFIG_USE_COMMON_STRUCT_CLK */
>  
>  /*
> - * struct clk - an machine class defined object / cookie.
> + * Global clock object, actual structure is declared per-machine
>   */
>  struct clk;
>  
> +static inline void clk_common_init(struct clk *clk) { }
> +
> +/*
> + * For !CONFIG_USE_COMMON_STRUCT_CLK, we don't enforce any atomicity
> + * requirements for clk_enable/clk_disable, so the prepare and unprepare
> + * functions are no-ops
> + */
> +int clk_prepare(struct clk *clk) { return 0; }
> +void clk_unprepare(struct clk *clk) { }
these should be static inline.  Otherwise these functions end up in many
files and so provoke a build failure.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
