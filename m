Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3AJRIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:08:23 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:60710 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3AJRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:08:22 -0500
Message-ID: <50EF0324.9060004@mvista.com>
Date: Thu, 10 Jan 2013 21:06:28 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, sameo@linux.intel.com,
        tony@atomide.com, kishon@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/14] usb: phy: nop: Handle power supply regulator for
 the PHY
References: <1357836694-30788-1-git-send-email-rogerq@ti.com> <1357836694-30788-5-git-send-email-rogerq@ti.com>
In-Reply-To: <1357836694-30788-5-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/10/2013 07:51 PM, Roger Quadros wrote:

> We use "vcc" as the supply name for the PHY's power supply.
> The power supply will be enabled during .init() and disabled
> during .shutdown()

> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/otg/nop-usb-xceiv.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
> index 163f972..1c6db10 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
[...]
> @@ -70,6 +72,11 @@ static int nop_init(struct usb_phy *phy)
>  {
>  	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
>  
> +	if (nop->vcc) {
> +		if (regulator_enable(nop->vcc))
> +			dev_err(phy->dev, "Failed to enable power\n");
> +	}

   Could be collapsed into single *if*.

> +
>  	if (nop->clk)
>  		clk_enable(nop->clk);
>  
> @@ -82,6 +89,11 @@ static void nop_shutdown(struct usb_phy *phy)
>  
>  	if (nop->clk)
>  		clk_disable(nop->clk);
> +
> +	if (nop->vcc) {
> +		if (regulator_disable(nop->vcc))
> +			dev_err(phy->dev, "Failed to disable power\n");
> +	}

   Same here.

WBR, Sergei

