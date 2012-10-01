Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2JASAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:00:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53446 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2JASAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:00:46 -0400
Message-ID: <5069DA49.7030901@mvista.com>
Date: Mon, 01 Oct 2012 20:00:41 +0200
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 6/7] usb: dwc3-omap: Minor fixes to get dt working
References: <1349087107-18229-1-git-send-email-kishon@ti.com> <1349087107-18229-7-git-send-email-kishon@ti.com>
In-Reply-To: <1349087107-18229-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-10-2012 12:25, Kishon Vijay Abraham I wrote:

> Includes few minor fixes in dwc3-omap like populating the compatible
> string in a correct way, extracting the utmi-mode property properly and
> changing the index of get_irq since irq of core is removed from hwmod
> entry.
> Also updated the documentation with dwc3-omap device tree binding
> information.
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
> ---
>   drivers/usb/dwc3/dwc3-omap.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index c19affa..25bd847 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -277,13 +277,13 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, omap);
>
> -	irq = platform_get_irq(pdev, 1);
> +	irq = platform_get_irq(pdev, 0);
>   	if (irq<  0) {
>   		dev_err(dev, "missing IRQ resource\n");
>   		return -EINVAL;
>   	}
>
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	if (!res) {
>   		dev_err(dev, "missing memory base resource\n");
>   		return -EINVAL;
> @@ -326,7 +326,7 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>
>   	utmi_mode = of_get_property(node, "utmi-mode",&size);
>   	if (utmi_mode&&  size == sizeof(*utmi_mode)) {
> -		reg |= *utmi_mode;
> +		reg |= be32_to_cpup(utmi_mode);

    Why not just use of_property_read_u32() instead of all this?

WBR, Sergei

