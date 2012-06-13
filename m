Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2FMRae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:30:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2FMRad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:30:33 -0400
MIME-Version: 1.0
In-Reply-To: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
References: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
Date: Wed, 13 Jun 2012 23:00:32 +0530
Message-ID: <CAHdPZaPYOUctZpUoGgp8q3jBHpsJXJnA7bsn_uszBXDtWMQdvA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mxs: Use kfree to fix build error
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linus.walleij@linaro.org, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Wed, Jun 13, 2012 at 10:36 PM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:
> commit 0bf7481 (pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails)
> introduced the following build error:
>
> drivers/pinctrl/pinctrl-mxs.c:140:3: error: implicit declaration of function 'free'
>
> Use kfree function instead.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> This applies against linux-next
>  drivers/pinctrl/pinctrl-mxs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
> index afb50ee..4ba4636 100644
> --- a/drivers/pinctrl/pinctrl-mxs.c
> +++ b/drivers/pinctrl/pinctrl-mxs.c
> @@ -137,7 +137,7 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
>
>  free_group:
>        if (!purecfg)
> -               free(group);
> +               kfree(group);
>  free:
>        kfree(new_map);
>        return ret;
> --
> 1.7.1
>
>



agh, i am very sorry that i didn't built this because it was not
selectable in make allconfig. (mine is x86 intel corei3),
anyway its wrong that i used  a userspace free instead kfree.

Thanks for fixing this.

Acked-by: Devendra Naga <devendra.aaru@gmail.com>
