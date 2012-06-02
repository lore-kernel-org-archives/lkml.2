Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2FBLgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:36:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52338 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab2FBLgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <1337518508-23282-1-git-send-email-morbidrsa@googlemail.com>
References: <1337518508-23282-1-git-send-email-morbidrsa@googlemail.com>
Date: Sat, 2 Jun 2012 13:36:10 +0200
Message-ID: <CAGH8bx63_fBKnD3P6c3gn9odAjj4bXzVrpsOyE6grHT7hOYy-g@mail.gmail.com>
Subject: Re: [PATCH] drivers/staging/line6/variax.c: Change some
 strict_strtoul() calls
From: morbid-rsa <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to ask about the status of this patch.

On Sun, May 20, 2012 at 2:55 PM, Johannes Thumshirn
<morbidrsa@googlemail.com> wrote:
> Changed strict_strtoul() calls which do not result in a need to change
> interfaces of called functions.
>
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/staging/line6/variax.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
> index d366222..efa496d 100644
> --- a/drivers/staging/line6/variax.c
> +++ b/drivers/staging/line6/variax.c
> @@ -353,10 +353,10 @@ static ssize_t variax_set_model(struct device *dev,
>  {
>        struct usb_line6_variax *variax =
>            usb_get_intfdata(to_usb_interface(dev));
> -       unsigned long value;
> +       u8 value;
>        int ret;
>
> -       ret = strict_strtoul(buf, 10, &value);
> +       ret = kstrtou8(buf, 10, &value);
>        if (ret)
>                return ret;
>
> @@ -387,10 +387,10 @@ static ssize_t variax_set_active(struct device *dev,
>  {
>        struct usb_line6_variax *variax =
>            usb_get_intfdata(to_usb_interface(dev));
> -       unsigned long value;
> +       u8 value;
>        int ret;
>
> -       ret = strict_strtoul(buf, 10, &value);
> +       ret = kstrtou8(buf, 10, &value);
>        if (ret)
>                return ret;
>
> --
> 1.7.7.6
>
