Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2IZSr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:47:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53961 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2IZSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <1348194419-11486-11-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
	<1348194419-11486-11-git-send-email-sboyd@codeaurora.org>
Date: Thu, 27 Sep 2012 00:17:56 +0530
Message-ID: <CADTbHxpOJ+5xMQ8NkntQtFezwsryzvMDBx8eroNjzfp_5b0DfQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] ARM: msm: Migrate to common clock framework
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> -static int pc_clk_set_rate(unsigned id, unsigned rate)
> +static int pc_clk_set_rate(struct clk_hw *hw, unsigned long new_rate,
> +                          unsigned long p_rate)
>  {
> -       /* The rate _might_ be rounded off to the nearest KHz value by the
> +       struct clk_pcom *p = to_clk_pcom(hw);
> +       unsigned id = p->id, rate = new_rate;
> +       int rc;
> +
> +       /*
> +        * The rate _might_ be rounded off to the nearest KHz value by the
>          * remote function. So a return value of 0 doesn't necessarily mean
>          * that the exact rate was set successfully.
>          */
> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
> -       if (rc < 0)
> -               return rc;
> -       else
> -               return (int)id < 0 ? -EINVAL : 0;
> -}
> -
> -static int pc_clk_set_min_rate(unsigned id, unsigned rate)
> -{
> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
> -       if (rc < 0)
> -               return rc;
> +       if (p->flags & CLKFLAG_MIN)
> +               rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);

You are missing if condition here checking the rc ?

>         else
> -               return (int)id < 0 ? -EINVAL : 0;
> -}
> -
> -static int pc_clk_set_max_rate(unsigned id, unsigned rate)
> -{
> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);

and else here i think for the MIN_FLAG if check.

> +               rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
>         if (rc < 0)
>                 return rc;
>         else
>                 return (int)id < 0 ? -EINVAL : 0;
>  }
>
--
Pankaj Jangra
