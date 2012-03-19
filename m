Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032573Ab2CSTAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:00:52 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:54294 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1032445Ab2CSTAv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120318140707.GC29638@S2101-09.ap.freescale.net>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120318140707.GC29638@S2101-09.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 19 Mar 2012 12:00:13 -0700
Message-ID: <CAJOA=zMQeGL-D-Zk83qhR1zaY-N+HfFufO3uhgConUbLHnab+g@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 7:07 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Another trivial comment.  But if there is an incremental patch, maybe
> consider to include it.
>
> On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
> ...
>> +#ifdef CONFIG_COMMON_CLK_DISABLE_UNUSED
>> +static int clk_disable_unused(void)
>> +{
>> +     struct clk *clk;
>> +     struct hlist_node *tmp;
>> +
>> +     mutex_lock(&prepare_lock);
>> +
>> +     hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
>> +             clk_disable_unused_subtree(clk);
>> +
>> +     hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
>> +             clk_disable_unused_subtree(clk);
>> +
>> +     mutex_unlock(&prepare_lock);
>> +
>> +     return 0;
>> +}
>> +late_initcall(clk_disable_unused);
>> +#else
>> +static inline int clk_disable_unused(struct clk *clk) { return 0; }
>
> This #else block seems completely unnecessary to me.
>
>> +#endif /* CONFIG_COMMON_CLK_DISABLE_UNUSED */

Oops.  This is a leftover from when there was a separate
drivers/clk/clk-debug.c which implemented this stuff.  I'll make a
cleanup series and roll all these little things into it.

Thanks,
Mike
