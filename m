Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab1EXESo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:18:44 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:39474 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab1EXESm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:18:42 -0400
Message-ID: <4DDB3184.2080301@st.com>
Date: Tue, 24 May 2011 09:48:12 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipin KUMAR <vipin.kumar@st.com>
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
References: <1305876469.326305.518470530485.1.gpush@pororo>
In-Reply-To: <1305876469.326305.518470530485.1.gpush@pororo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 12:57 PM, Jeremy Kerr wrote:
> +static DEFINE_SPINLOCK(enable_lock);
> +static DEFINE_MUTEX(prepare_lock);

Probably all clocks can be handled separately, i.e. single lock for all
of them will make system slower. Suppose i want to enable UART's clock
then why should spi code be waiting for the lock.
So, we should have per clk lock.

<...>

> +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
> +               const char *name)
> +{
> +       struct clk *clk;
> +
> +       clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +       if (!clk)
> +               return NULL;
> +
> +       clk->name = name;
> +       clk->ops = ops;
> +       clk->hw = hw;
> +       hw->clk = clk;
> +
> +       /* Query the hardware for parent and initial rate */
> +

Can remove this blank line.

> +       if (clk->ops->get_parent)
> +               /* We don't to lock against prepare/enable here, as
> +                * the clock is not yet accessible from anywhere */

Shouldn't we use following style for multi-line comments.
/*
 * ....
 */

> +               clk->parent = clk->ops->get_parent(clk->hw);
> +
> +       if (clk->ops->recalc_rate)
> +               clk->rate = clk->ops->recalc_rate(clk->hw);
> +
> +

Can remove one of these blank lines.

-- 
viresh
