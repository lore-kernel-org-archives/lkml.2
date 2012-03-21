Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab2CUUdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:33:15 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36447 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760361Ab2CUUdL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 21 Mar 2012 13:32:49 -0700
Message-ID: <CAJOA=zOCGqUckxXiv5-N6oNXUyMExmEOC6FvdWLJmS_r+QMbTQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: fixed-rate: Don't open code kstrdup()
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
> Save a little code by using the library function.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi Mark,

Thanks for the patch.  I've already solved this in my clk-fixes branch
(working on it now, not yet on the list).  I'm going to re-use the
same approach for the fixed-rate clock as is used for the divider and
gate; the registration functions for those types store the parent_name
in the struct clk_foo and use kstrdup as your patch does below.

Thanks again,
Mike

> ---
>  drivers/clk/clk-fixed-rate.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index 90c79fb..cf84e41 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -45,7 +45,6 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>  {
>        struct clk_fixed_rate *fixed;
>        char **parent_names = NULL;
> -       u8 len;
>
>        fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
>
> @@ -63,14 +62,10 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>                if (! parent_names)
>                        goto out;
>
> -               len = sizeof(char) * strlen(parent_name);
> -
> -               parent_names[0] = kmalloc(len, GFP_KERNEL);
> +               parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
>
>                if (!parent_names[0])
>                        goto out;
> -
> -               strncpy(parent_names[0], parent_name, len);
>        }
>
>  out:
> --
> 1.7.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
