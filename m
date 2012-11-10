Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2KJNnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:43:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64026 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KJNnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <1352538822-28221-1-git-send-email-bjorn@mork.no>
References: <509D5BCD.3010901@pacbell.net>
	<1352538822-28221-1-git-send-email-bjorn@mork.no>
Date: Sat, 10 Nov 2012 14:43:03 +0100
Message-ID: <CAMgPeKWfaNGnR=EDDEii89sP0MwhoopR-iv=pHHa5vgs-UHf+A@mail.gmail.com>
Subject: Re: [PATCH usb-linus] USB: keyspan: fix typo causing GPF on open
From: Johan Hovold <jhovold@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Richard <richjunk@pacbell.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 10:13 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Commit f79b2d0f (USB: keyspan: fix NULL-pointer dereferences and
> memory leaks) had a small typo which made the driver use wrong
> offsets when mapping serial port private data.  This results in
> in a GPF when the port is opened.
>
> Reported-by: Richard <richjunk@pacbell.net>
> Cc: <stable@vger.kernel.org>
> Cc: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Acked-by: Johan Hovold <jhovold@gmail.com>

> ---
> Hello Richard,
>
> I wonder if you are able to test and verify this?  I do not guarantee
> that there aren't other issues around, but this small typo looked like
> an obvious killer...

Good catch, Bjørn.

Greg, this one needs to be backported to v3.6.x.

Note that the usb_get_serial_data call below was simply redundant,
so that part is really a clean up rather than part of the fix.

Thanks,
Johan

> Bjørn
>
>  drivers/usb/serial/keyspan.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 7179b0c..cff8dd5 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -2430,7 +2430,7 @@ static void keyspan_release(struct usb_serial *serial)
>  static int keyspan_port_probe(struct usb_serial_port *port)
>  {
>         struct usb_serial *serial = port->serial;
> -       struct keyspan_port_private *s_priv;
> +       struct keyspan_serial_private *s_priv;
>         struct keyspan_port_private *p_priv;
>         const struct keyspan_device_details *d_details;
>         struct callbacks *cback;
> @@ -2445,7 +2445,6 @@ static int keyspan_port_probe(struct usb_serial_port *port)
>         if (!p_priv)
>                 return -ENOMEM;
>
> -       s_priv = usb_get_serial_data(port->serial);
>         p_priv->device_details = d_details;
>
>         /* Setup values for the various callback routines */
> --
> 1.7.10.4
>
