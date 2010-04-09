Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0DIVlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:41:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:37679 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757888Ab0DIVlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:41:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX191huxfUVt1hrIGZ8ptp0KfsJcPEo/6xMhLroxN/n
	1sVIRqlAeqvh91
Message-ID: <4BBF9EE7.50707@gmx.de>
Date: Fri, 09 Apr 2010 23:40:55 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/16] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-9-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-9-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> From: Chris Ball <cjb@laptop.org>
> 
> The i2c transactions involved in detecting LVDS (9 seconds) and TMDS
> (16 seconds) add an extra 25 seconds to viafb load time on the XO-1.5.

I don't like the idea of OLPC specific code. Isn't there any way to 
speed this up in general?
There is not yet even an option for OLPC_XO_1_5 (in contrast to 
CONFIG_OLPC) in mainline. Is such a thing planned?
I can't really see anything that would speak for accepting this patch 
now in current mainline, sorry.


Thanks,

Florian Tobias Schandinat

> [jc: minor merge conflict fixed]
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  drivers/video/via/hw.c  |    4 ++++
>  drivers/video/via/lcd.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> index 7be462e..47ba09a 100644
> --- a/drivers/video/via/hw.c
> +++ b/drivers/video/via/hw.c
> @@ -2054,6 +2054,10 @@ static void init_gfx_chip_info(struct pci_dev *pdev,
>  
>  static void init_tmds_chip_info(void)
>  {
> +#ifdef CONFIG_OLPC_XO_1_5
> +	if (machine_is_olpc())
> +		return;
> +#endif
>  	viafb_tmds_trasmitter_identify();
>  
>  	if (INTERFACE_NONE == viaparinfo->chip_info->tmds_chip_info.
> diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
> index e0e2310..37a9746 100644
> --- a/drivers/video/via/lcd.c
> +++ b/drivers/video/via/lcd.c
> @@ -208,6 +208,10 @@ static bool lvds_identify_integratedlvds(void)
>  
>  int viafb_lvds_trasmitter_identify(void)
>  {
> +#ifdef CONFIG_OLPC_XO_1_5
> +	if (machine_is_olpc())
> +		return FAIL;
> +#endif
>  	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
>  	if (viafb_lvds_identify_vt1636()) {
>  		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;

