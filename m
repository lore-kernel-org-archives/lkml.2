Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1JTJq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:46:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39313 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JTJq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <1319062768-26391-2-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com> <1319062768-26391-2-git-send-email-swarren@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 20 Oct 2011 17:46:07 +0800
Message-ID: <CAGsJ_4z3xs3CrKM37R_=NG3dhSrmWqxFq9f52zPQ3OATLns4oQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Remove unsafe __refdata
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/20 Stephen Warren <swarren@nvidia.com>:
> A pin controller's pin definitions are used both during pinctrl_register()
> and pinctrl_unregister(). The latter happens outside of __init/__devinit
> time, and hence it is unsafe to mark the pin array as __refdata.

Thanks.
Acked-by: Barry Song <Baohua.Song@csr.com>

missed this when porting prima2 pinmux driver. is this __refdata used
just due to a typo?
i don't find prima2 pinctrl_pin_desc tables uses any code/data in __init/__exit.

if we need the table to be in init section, we should have used
__initconst/__initdata instead.

>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pinctrl/pinmux-sirf.c |    2 +-
>  drivers/pinctrl/pinmux-u300.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
> index cad4f5d..3bc083c 100644
> --- a/drivers/pinctrl/pinmux-sirf.c
> +++ b/drivers/pinctrl/pinmux-sirf.c
> @@ -30,7 +30,7 @@
>  * pad list for the pinmux subsystem
>  * refer to CS-131858-DC-6A.xls
>  */
> -static const struct pinctrl_pin_desc __refdata sirfsoc_pads[] = {
> +static const struct pinctrl_pin_desc sirfsoc_pads[] = {
>        PINCTRL_PIN(4, "pwm0"),
>        PINCTRL_PIN(5, "pwm1"),
>        PINCTRL_PIN(6, "pwm2"),
> diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
> index be6e04d..ed8bcd8 100644
> --- a/drivers/pinctrl/pinmux-u300.c
> +++ b/drivers/pinctrl/pinmux-u300.c
> @@ -179,7 +179,7 @@
>  #define U300_NUM_PADS 467
>
>  /* Pad names for the pinmux subsystem */
> -static const struct pinctrl_pin_desc __refdata u300_pads[] = {
> +static const struct pinctrl_pin_desc u300_pads[] = {
>        /* Pads along the top edge of the chip */
>        PINCTRL_PIN(0, "P PAD VDD 28"),
>        PINCTRL_PIN(1, "P PAD GND 28"),
> --
> 1.7.0.4

-barry
