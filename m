Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2CROGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 10:06:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2CROGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 10:06:32 -0400
Date: Sun, 18 Mar 2012 22:07:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
Message-ID: <20120318140707.GC29638@S2101-09.ap.freescale.net>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331878280-2758-3-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another trivial comment.  But if there is an incremental patch, maybe
consider to include it.

On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
...
> +#ifdef CONFIG_COMMON_CLK_DISABLE_UNUSED
> +static int clk_disable_unused(void)
> +{
> +	struct clk *clk;
> +	struct hlist_node *tmp;
> +
> +	mutex_lock(&prepare_lock);
> +
> +	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
> +		clk_disable_unused_subtree(clk);
> +
> +	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
> +		clk_disable_unused_subtree(clk);
> +
> +	mutex_unlock(&prepare_lock);
> +
> +	return 0;
> +}
> +late_initcall(clk_disable_unused);
> +#else
> +static inline int clk_disable_unused(struct clk *clk) { return 0; }

This #else block seems completely unnecessary to me.

> +#endif /* CONFIG_COMMON_CLK_DISABLE_UNUSED */

-- 
Regards,
Shawn
