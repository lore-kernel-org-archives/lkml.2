Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2KTKFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:05:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35001 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <1353403339-11679-4-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-4-git-send-email-dmitry.torokhov@gmail.com>
Date: Tue, 20 Nov 2012 15:35:42 +0530
Message-ID: <CAKohpo=PMQanmVyo22HoqoXT2e3DUU8coPS85wDPDZjyFsRunQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] CLK: add more managed APIs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> When converting a driver to managed resources it is desirable to be able to
> manage all resources in the same fashion. This change allows managing clocks
> in the same way we manage all otehr resources.

s/otehr/other

> This adds the following managed APIs:
>
> - devm_clk_prepare()/devm_clk_unprepare();
> - devm_clk_enable()/devm_clk_disable();
> - devm_clk_preapre_enable()/devm_clk_diable_unprepare().
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/clk/clk-devres.c |  91 +++++++++++++++++++++++++++++++---------
>  include/linux/clk.h      | 105 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 177 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
> index 8f57154..2703fa9 100644
> --- a/drivers/clk/clk-devres.c
> +++ b/drivers/clk/clk-devres.c
> @@ -9,6 +9,33 @@
>  #include <linux/export.h>
>  #include <linux/gfp.h>
>
> +static int devm_clk_match(struct device *dev, void *res, void *data)
> +{
> +       struct clk **c = res;
> +       if (!c || !*c) {
> +               WARN_ON(!c || !*c);

I know, you just moved this routine higher in the file. But above two
lines look duplicated. Can we just use WARN(); here?

> +               return 0;
> +       }
> +       return *c == data;
> +}
> +
> +
> +static int devm_clk_create_devres(struct device *dev,
> +                                 struct clk *clk,
> +                                 void (*release)(struct device *, void *))

This didn't came in two lines?

> +{

Apart from that, looks fine.

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
