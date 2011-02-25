Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1BYTW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:22:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34089 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1BYTW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110223021221.17638.42707.stgit@localhost6.localdomain6>
References: <20110223021221.17638.42707.stgit@localhost6.localdomain6>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Feb 2011 12:22:37 -0700
X-Google-Sender-Auth: g1zHof1eWBnLoHprpadbV-VUJng
Message-ID: <AANLkTinx2YxOs3Y-XDHaWe44Bw8HqiMyanouV5Bo3KuX@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: Relax the device_type restriction from of_serial
To: devicetree-discuss@lists.ozlabs.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Ben,

I forgot to cc you guys on this patch.  Greg has it in his tree, but I
wanted to make sure you noticed it.  If you have any objections, let
me know and I'll ask Greg to drop it.

Thanks,
g.


On Tue, Feb 22, 2011 at 7:12 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> There is no need to test for a device_type property in ns8250
> compatible serial ports.  device_type is an OpenFirmware property that
> is not required when using the flattened tree representation.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/tty/serial/of_serial.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 5c7abe4..6a18ca6 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -160,17 +160,17 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
>  * A few common types, add more as needed.
>  */
>  static struct of_device_id __devinitdata of_platform_serial_table[] = {
> -       { .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
> -       { .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
> -       { .type = "serial", .compatible = "ns16550a", .data = (void *)PORT_16550A, },
> -       { .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
> -       { .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
> -       { .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },
> +       { .compatible = "ns8250",   .data = (void *)PORT_8250, },
> +       { .compatible = "ns16450",  .data = (void *)PORT_16450, },
> +       { .compatible = "ns16550a", .data = (void *)PORT_16550A, },
> +       { .compatible = "ns16550",  .data = (void *)PORT_16550, },
> +       { .compatible = "ns16750",  .data = (void *)PORT_16750, },
> +       { .compatible = "ns16850",  .data = (void *)PORT_16850, },
>  #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
> -       { .type = "serial", .compatible = "ibm,qpace-nwp-serial",
> -                                       .data = (void *)PORT_NWPSERIAL, },
> +       { .compatible = "ibm,qpace-nwp-serial",
> +               .data = (void *)PORT_NWPSERIAL, },
>  #endif
> -       { .type = "serial",                           .data = (void *)PORT_UNKNOWN, },
> +       { .type = "serial",         .data = (void *)PORT_UNKNOWN, },
>        { /* end of list */ },
>  };
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
