Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2KKCoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:44:44 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40622 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2KKCon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:44:43 -0500
MIME-Version: 1.0
In-Reply-To: <1352600980.23129.5.camel@phoenix>
References: <1352600980.23129.5.camel@phoenix>
Date: Sun, 11 Nov 2012 08:14:42 +0530
X-Google-Sender-Auth: BLZMGVXxaAzgGp_5osnyRlyrXIU
Message-ID: <CAOh2x=kGzg6eFph5OF9E8mosR0C+yP+aB1R15aiJG5OvwoErrw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: spear: Staticize non-exported symbols
From: viresh kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 7:59 AM, Axel Lin <axel.lin@ingics.com> wrote:
> They are not referenced outside of this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/spear/pinctrl-spear.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
> index b1fd6ee..9a4dd4e 100644
> --- a/drivers/pinctrl/spear/pinctrl-spear.c
> +++ b/drivers/pinctrl/spear/pinctrl-spear.c
> @@ -121,9 +121,10 @@ static void spear_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
>         seq_printf(s, " " DRIVER_NAME);
>  }
>
> -int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
> -                                struct device_node *np_config,
> -                                struct pinctrl_map **map, unsigned *num_maps)
> +static int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
> +                                       struct device_node *np_config,
> +                                       struct pinctrl_map **map,
> +                                       unsigned *num_maps)
>  {
>         struct spear_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
>         struct device_node *np;
> @@ -168,8 +169,9 @@ int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> -void spear_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
> -               struct pinctrl_map *map, unsigned num_maps)
> +static void spear_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
> +                                     struct pinctrl_map *map,
> +                                     unsigned num_maps)
>  {
>         kfree(map);
>  }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
