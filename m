Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2J2GWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:22:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2J2GV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <20121028231608.685974874@decadent.org.uk>
References: <20121028231536.970033833@decadent.org.uk> <20121028231608.685974874@decadent.org.uk>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Mon, 29 Oct 2012 07:21:37 +0100
Message-ID: <CAHkwnC8awjvFxM1x2VGpG0K44zR2jTo8MRQk1v1YwJwrKxMYnA@mail.gmail.com>
Subject: Re: [ 102/105] usb: gadget: at91_udc: fix dt support
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 12:17 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.

Hi Ben,
this patch is only useful only for kernel version 3.4 and later,
because the dt support was
introduced in the 3.4 release with the following commit:
     d1494a340807c9b77aa44bc8d8166353df4cf1c3
so i think it's best to doesn't apply this patch.

Best regards
-- 
Fabio Porcedda

> ------------------
>
> From: Fabio Porcedda <fabio.porcedda@gmail.com>
>
> commit 9c6d196d5aa35e07482f23c3e37755e7a82140e0 upstream.
>
> Don't fail the initialization check for the platform_data
> if there is avaiable an associated device tree node.
>
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/gadget/at91_udc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -1735,7 +1735,7 @@ static int __devinit at91udc_probe(struc
>         int             retval;
>         struct resource *res;
>
> -       if (!dev->platform_data) {
> +       if (!dev->platform_data && !pdev->dev.of_node) {
>                 /* small (so we copy it) but critical! */
>                 DBG("missing platform_data\n");
>                 return -ENODEV;
>
>
