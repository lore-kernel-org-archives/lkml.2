Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0HIKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:52:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40655 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab0HIKwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tyDbSgVjuoVMSTJy9yI/P1/txHSq+q32wV+8gvJ1TbpRIw6c+YGkGZnMSgMxvGgtGX
         5lR0Kd9uTE6hrQFrZfQzjbQeyB+uvT3DAx4ZNlZKqoQLqmm6lRrv4j+LGX+Fx0NdNUTl
         pUcpSJRJ1VLztavAAnXkJb8rItvI4+mtAMaCU=
MIME-Version: 1.0
In-Reply-To: <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
References: <cover.1281002833.git.m.nazarewicz@samsung.com>
	<4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
Date: Mon, 9 Aug 2010 13:52:38 +0300
Message-ID: <AANLkTi=CMekYvS5yLFmjhKHJovFFmoE1tEfXCYOWTUX4@mail.gmail.com>
Subject: Re: [PATCHv6 1/7] USB: gadget: storage_common: fixed warning building 
	mass storage function
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 1:27 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> The "nofua" attribute is used in the File-Storage Gadget but the
> functions handling it are defined in storage_common.c (which may be
> not a bad thing if anyone will want to port tho "nofua" attribute to
> mass storage function) which causes the following warnings:
>
> drivers/usb/gadget/storage_common.c:718: \
>  warning: ‘fsg_show_nofua’ defined but not used
> drivers/usb/gadget/storage_common.c:782: \
>  warning: ‘fsg_store_nofua’ defined but not used
>
> Adding __maybe_unused fixes this issue.
>
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/usb/gadget/storage_common.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 484acfb..3379cc3 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -715,8 +715,8 @@ static ssize_t fsg_show_ro(struct device *dev, struct device_attribute *attr,
>                                  : curlun->initially_ro);
>  }
>
> -static ssize_t fsg_show_nofua(struct device *dev, struct device_attribute *attr,
> -                             char *buf)
> +static ssize_t __maybe_unused
> +fsg_show_nofua(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>        struct fsg_lun  *curlun = fsg_lun_from_dev(dev);
>
> @@ -779,9 +779,9 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>        return rc;
>  }
>
> -static ssize_t fsg_store_nofua(struct device *dev,
> -                              struct device_attribute *attr,
> -                              const char *buf, size_t count)
> +static ssize_t __maybe_unused
> +fsg_store_nofua(struct device *dev, struct device_attribute *attr,
> +               const char *buf, size_t count)
>  {
>        struct fsg_lun  *curlun = fsg_lun_from_dev(dev);
>        unsigned long   nofua;
> --
> 1.7.1
>
>

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

-- 
With Best Regards,
Andy Shevchenko
