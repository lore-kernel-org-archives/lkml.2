Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3ACMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:52:39 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:61622 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3ACMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:52:37 -0500
Message-ID: <50E57F10.6030402@mvista.com>
Date: Thu, 03 Jan 2013 16:52:32 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        keshava_mgowda@ti.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 13/22] mfd: omap-usb-host: override number of ports
 from platform data
References: <1357138842-28964-1-git-send-email-rogerq@ti.com> <1357138842-28964-14-git-send-email-rogerq@ti.com>
In-Reply-To: <1357138842-28964-14-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-01-2013 19:00, Roger Quadros wrote:

> Both OMAP4 and 5 exhibit the same revision ID in the REVISION register
> but they have different number of ports i.e. 2 and 3 respectively.
> So we can't rely on REVISION register for number of ports on OMAP5
> and depend on platform data (or device tree) instead.

> Signed-off-by: Roger Quadros <rogerq@ti.com>
[...]

> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 5edb828..710460d 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -497,19 +497,27 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>   	 */
>   	pm_runtime_put_sync(dev);
>
> -	switch (omap->usbhs_rev) {
> -	case OMAP_USBHS_REV1:
> -		omap->nports = 3;
> -		break;
> -	case OMAP_USBHS_REV2:
> -		omap->nports = 2;
> -		break;
> -	default:
> -		omap->nports = OMAP3_HS_USB_PORTS;
> -		dev_dbg(dev,
> -		  "USB HOST Rev : 0x%d not recognized, assuming %d ports\n",
> -		   omap->usbhs_rev, omap->nports);
> -		break;
> +	/*
> +	 * If platform data contains nports then use that
> +	 * else make out number of ports from USBHS revision
> +	 */
> +	if (pdata->nports) {
> +		omap->nports = pdata->nports;
> +	} else {
> +		switch (omap->usbhs_rev) {
> +		case OMAP_USBHS_REV1:
> +			omap->nports = 3;
> +			break;
> +		case OMAP_USBHS_REV2:
> +			omap->nports = 2;
> +			break;
> +		default:
> +			omap->nports = OMAP3_HS_USB_PORTS;
> +			dev_dbg(dev,
> +			"USB HOST Rev:0x%d not recognized, assuming %d ports\n",

    Please indent the string to the right somewhat, as it was before.

WBR, Sergei

