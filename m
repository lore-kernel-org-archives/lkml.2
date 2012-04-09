Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2DIPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:03:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39012 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2DIPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:03:11 -0400
Message-ID: <4F82FA2A.3090604@wwwdotorg.org>
Date: Mon, 09 Apr 2012 09:03:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] pinctrl: add some error checking for user interfaces
References: <1333967409-8168-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1333967409-8168-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 04:30 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch can avoid kernel oops in case the mux or config
> function is not supported by driver.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  drivers/pinctrl/pinconf.c |    4 ++++
>  drivers/pinctrl/pinmux.c  |   15 +++++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
> index eb3a14f..384dcc1 100644
> --- a/drivers/pinctrl/pinconf.c
> +++ b/drivers/pinctrl/pinconf.c
> @@ -448,8 +448,12 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
>  static int pinconf_pins_show(struct seq_file *s, void *what)
>  {
>  	struct pinctrl_dev *pctldev = s->private;
> +	const struct pinconf_ops *ops = pctldev->desc->confops;
>  	unsigned i, pin;
>  
> +	if (!ops || !ops->pin_config_get)
> +		return 0;

I don't think this is necessary; it looks like this function (and those
it calls) always checks ops where they're used.

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 8849830..ade661d 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -323,6 +323,11 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
>  	const unsigned *pins;
>  	unsigned num_pins;
>  
> +	if (!pmxops) {
> +		dev_err(pctldev->dev, "dose not support mux functron\n");

s/dose/does/
s/functron/function/

