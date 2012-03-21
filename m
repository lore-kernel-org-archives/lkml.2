Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348Ab2CUUhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:37:07 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44821 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760291Ab2CUUhE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <1332360082-25092-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-3-git-send-email-broonie@opensource.wolfsonmicro.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 21 Mar 2012 13:36:36 -0700
Message-ID: <CAJOA=zP4fbvZf2LFvV8s1DYqMZbbOrCZfWQxY53GOPqvh=R+KQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] clk: Provide dummy clk_unregister()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 1:01 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> While there's no actual implementation behind it having the call to use
> in drivers makes them feel neater from a driver author point of view. An
> actual implementation can wait for someone who needs to use the function
> in a real system.

Thanks for the patch Mark.  I'll include this in my fixes branch.

Regards,
Mike

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/clk/clk.c            |   12 ++++++++++++
>  include/linux/clk-provider.h |    1 +
>  2 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 33ef0df..31419ca 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1344,6 +1344,18 @@ struct clk *clk_register(struct device *dev, const char *name,
>  }
>  EXPORT_SYMBOL_GPL(clk_register);
>
> +/**
> + * clk_unregister - unregister a currently registered clock
> + * @clk: clock to unregister
> + *
> + * Currently unimplemented.
> + */
> +int clk_unregister(struct clk *clk)
> +{
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(clk_unregister);
> +
>  /***        clk rate change notifiers        ***/
>
>  /**
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 340acbc..57c0bd1 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -275,6 +275,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  struct clk *clk_register(struct device *dev, const char *name,
>                const struct clk_ops *ops, struct clk_hw *hw,
>                const char **parent_names, u8 num_parents, unsigned long flags);
> +int clk_unregister(struct clk *clk);
>
>  /* helper functions */
>  const char *__clk_get_name(struct clk *clk);
> --
> 1.7.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
