Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1GGI2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:28:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53316 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1GGI2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <1310022039-25599-1-git-send-email-ravishankarkm32@gmail.com>
References: <1310022039-25599-1-git-send-email-ravishankarkm32@gmail.com>
Date: Thu, 7 Jul 2011 12:28:21 +0400
Message-ID: <CAHj3AVkz11sxubOyoJBwh6aa+SO1TGh3rYCwPSr-SJ8V1fF4EQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] Staging: comedi: fix warning issue in unioxx5.c
From: Denis Kirjanov <kirjanov@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if this patch improves code readability

On Thu, Jul 7, 2011 at 11:00 AM, Ravishankar <ravishankarkm32@gmail.com> wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
>
> This is a patch to the unioxx5.c file that fixes up a  warning:line over 80 charcter found by the checkpatch.pl tool
>
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/unioxx5.c |   25 ++++++++++++++++++-------
>  1 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 598884e..9b311c7 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -75,8 +75,13 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>  /* 'private' structure for each subdevice */
>  struct unioxx5_subd_priv {
>        int usp_iobase;
> -       unsigned char usp_module_type[12];      /* 12 modules. each can be 70L or 73L */
> -       unsigned char usp_extra_data[12][4];    /* for saving previous written value for analog modules */
> +       unsigned char usp_module_type[12];      /* 12 modules. each can be 70L
> +                                                * or 73L
> +                                               */
> +       unsigned char usp_extra_data[12][4];    /* for saving previous written
> +                                                * value for analog modules
> +                                               */
> +
>        unsigned char usp_prev_wr_val[3];       /* previous written value */
>        unsigned char usp_prev_cn_val[3];       /* previous channel value */
>  };
> @@ -398,7 +402,10 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
>        *data &= mask;
>
>        if (channel_offset > 1)
> -               channel -= 2 << channel_offset; /* this operation is created for correct readed value to 0 or 1 */
> +               channel -= 2 << channel_offset; /* this operation is created for
> +                                                * correct readed value to
> +                                                * 0 or 1
> +                                               */
>
>        *data >>= channel;
>        return 1;
> @@ -444,7 +451,9 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
>        usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
>
>        /* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
> -       outb(module + 1, usp->usp_iobase + 5);  /* sending module number to card(1 .. 12) */
> +       outb(module + 1, usp->usp_iobase + 5);  /* sending module number
> +                                                * to card (1..12)
> +                                               */
>        outb('W', usp->usp_iobase + 6); /* sends (W)rite command to module */
>
>        /* sending for bytes to module(one byte per cycle iteration) */
> @@ -475,7 +484,9 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
>        }
>
>        __unioxx5_analog_config(usp, channel);
> -       outb(module_no + 1, usp->usp_iobase + 5);       /* sends module number to card(1 .. 12) */
> +       outb(module_no + 1, usp->usp_iobase + 5);       /* sends module number
> +                                                        * to card (1. .12)
> +                                                       */
>        outb('V', usp->usp_iobase + 6); /* sends to module (V)erify command */
>        control = inb(usp->usp_iobase); /* get control register byte */
>
> --
> 1.6.5.2
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Regards,
Denis
