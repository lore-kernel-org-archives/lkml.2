Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab0CaIe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:34:26 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:50635 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab0CaIeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qfzmUqbUoywbOoK6bAE7ASbWjIb4xrci1lqP3EMTSG8v3VQY52sGk8K4WPC7nHYjLt
         Zyc6K6YsaD+eIA5+8QYywp5SoKLhBKgp79md+pdI0Kkg7eXtWzIOvZMLusenma5ZJW83
         7ZrdXwpAxG4PxK3N8QZy2qwh2UIa6I09Jp+nA=
MIME-Version: 1.0
In-Reply-To: <1269982719.1507.71.camel@Joe-Laptop.home>
References: <1269979872-14677-1-git-send-email-soerenmoeller2001@gmail.com>
	 <1269982719.1507.71.camel@Joe-Laptop.home>
Date: Wed, 31 Mar 2010 10:34:20 +0200
Message-ID: <6797ac6e1003310134y9c333y1fc6811032b2f174@mail.gmail.com>
Subject: Re: [PATCH] Staging: quatech_usb2: fix coding style issues
From: =?ISO-8859-1?B?U/hyZW4gTfhsbGVy?= <soerenmoeller2001@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, richard@audacityteam.org, andre.goddard@gmail.com,
       nm127@freemail.hu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Joe Perches <joe@perches.com>
>
> On Tue, 2010-03-30 at 20:11 +0000, Soeren Moeller wrote:
> > This is a patch to the file quatech_usb2.c that fixes two space before tabular and one line of more than 80 characters warnings found by checkpatch.pl
> > -                             tty_insert_flip_string(tty_st,
> > -                                     &((unsigned char *)(urb->transfer_buffer)
> > -                                             )[i],
> > -                                     1);
> > +                             tty_insert_flip_string(tty_st, &(
> > +                                             (unsigned char *)
> > +                                             (urb->transfer_buffer)
> > +                                     )[i], 1);
>
> I think this is unsightly.
> Perhaps a macro instead?
>

The macro seems like a good idea, it makes the code a lot more readable.
Thanks for your response

Regards
Sören Möller

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/quatech_usb2/quatech_usb2.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
> index 1561f74..d14792a 100644
> --- a/drivers/staging/quatech_usb2/quatech_usb2.c
> +++ b/drivers/staging/quatech_usb2/quatech_usb2.c
> @@ -109,12 +109,15 @@ static int debug;
>  #define  QT2_LINE_STATUS_REGISTER       0x05
>  #define  QT2_MODEM_STATUS_REGISTER      0x06
>
> +/* handy macro for extracting a byte from a data read transfer buffer */
> +#define URB_TBUF(urb, pos) (((unsigned char *)(urb->transfer_buffer))[pos])
> +
>  /* handy macros for doing escape sequence parsing on data reads */
> -#define THISCHAR       ((unsigned char *)(urb->transfer_buffer))[i]
> -#define NEXTCHAR       ((unsigned char *)(urb->transfer_buffer))[i + 1]
> -#define THIRDCHAR      ((unsigned char *)(urb->transfer_buffer))[i + 2]
> -#define FOURTHCHAR     ((unsigned char *)(urb->transfer_buffer))[i + 3]
> -#define FIFTHCHAR      ((unsigned char *)(urb->transfer_buffer))[i + 4]
> +#define THISCHAR       URB_TBUF(urb, i + 0)
> +#define NEXTCHAR       URB_TBUF(urb, i + 1)
> +#define THIRDCHAR      URB_TBUF(urb, i + 2)
> +#define FOURTHCHAR     URB_TBUF(urb, i + 3)
> +#define FIFTHCHAR      URB_TBUF(urb, i + 4)
>
>  static const struct usb_device_id quausb2_id_table[] = {
>        {USB_DEVICE(USB_VENDOR_ID_QUATECH, QUATECH_SSU2_100)},
> @@ -1649,9 +1652,7 @@ __func__);
>                        if (tty_st && urb->actual_length) {
>                                tty_buffer_request_room(tty_st, 1);
>                                tty_insert_flip_string(tty_st,
> -                                       &((unsigned char *)(urb->transfer_buffer)
> -                                               )[i],
> -                                       1);
> +                                                      &URB_TBUF(urb, i), 1);
>                        }
>                } /*endfor*/
>                tty_flip_buffer_push(tty_st);
>
>
