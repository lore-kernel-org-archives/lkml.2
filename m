Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0DFDWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:22:01 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:51678 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0DFDVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z2WowlEu4hU54UhSvTT3yTmUIX17IXStNA2kC3F89Vsj6TyVyJ2zWHlL34do+VOSTt
         EkVr8jKwqT/Lm1thTPTmOFjdoQY9Ya5RqfOKnllUvVEmApQlSDSOIl5oDRUqwu5JYkxg
         Lzw8R8xwwJ7+7+Ifbbz9IatNZN4GxAXqxcLN0=
MIME-Version: 1.0
In-Reply-To: <1270176948.3847.1.camel@eight.analog.com>
References: <1270176948.3847.1.camel@eight.analog.com>
Date: Tue, 6 Apr 2010 11:21:53 +0800
Message-ID: <j2r4e5ebad51004052021id38109fcif10d1805e2600b32@mail.gmail.com>
Subject: Re: [PATCH] IIO: struct iio_dev_attr should be defined as static.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-iio <linux-iio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Any comments?

Sonic

On Fri, Apr 2, 2010 at 10:55 AM, sonic zhang <sonic.adi@gmail.com> wrote:
>
> Otherwise link errors "multiple definition of `iio_dev_attr_mode'"
> are reported when compile multiple different iio drivers with the
> same attribute name.
>
> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
> ---
>  drivers/staging/iio/sysfs.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
> index e501e13..39d207e 100644
> --- a/drivers/staging/iio/sysfs.h
> +++ b/drivers/staging/iio/sysfs.h
> @@ -95,16 +95,16 @@ struct iio_const_attr {
>                        .val2 = _val2 }
>
>  #define IIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)    \
> -       struct iio_dev_attr iio_dev_attr_##_name                \
> +       static struct iio_dev_attr iio_dev_attr_##_name         \
>        = IIO_ATTR(_name, _mode, _show, _store, _addr)
>
>
>  #define IIO_DEVICE_ATTR_2(_name, _mode, _show, _store, _addr, _val2)   \
> -       struct iio_dev_attr iio_dev_attr_##_name                        \
> +       static struct iio_dev_attr iio_dev_attr_##_name                 \
>        = IIO_ATTR_2(_name, _mode, _show, _store, _addr, _val2)
>
>  #define IIO_CONST_ATTR(_name, _string)                                 \
> -       struct iio_const_attr iio_const_attr_##_name                    \
> +       static struct iio_const_attr iio_const_attr_##_name                     \
>        = { .string = _string,                                          \
>            .dev_attr = __ATTR(_name, S_IRUGO, iio_read_const_attr, NULL)}
>
> --
> 1.6.0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
