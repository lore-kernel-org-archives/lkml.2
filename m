Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1KWQTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:19:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47339 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1KWQTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:19:42 -0500
MIME-Version: 1.0
In-Reply-To: <1321999366-23784-11-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-11-git-send-email-corentincj@iksaif.net>
Date: Wed, 23 Nov 2011 17:19:40 +0100
Message-ID: <CANq1E4TwHt8RhW2nn_7W0MqiLd5d6VEw1c7QUP7JYniA2yZK=Q@mail.gmail.com>
Subject: Re: [PATCH 10/15] samsung-laptop: cleanup KConfig
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02 PM, Corentin Chary <corentincj@iksaif.net> wrote:
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>  drivers/platform/x86/Kconfig |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 7f43cf8..2f7a9a7 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -744,13 +744,16 @@ config XO15_EBOOK
>
>  config SAMSUNG_LAPTOP
>        tristate "Samsung Laptop driver"
> -       depends on RFKILL && BACKLIGHT_CLASS_DEVICE && X86
> +       depends on X86
> +       depends on RFKILL || RFKILL = n
> +       depends on BACKLIGHT_CLASS_DEVICE
>        ---help---
>          This module implements a driver for a wide range of different
>          Samsung laptops.  It offers control over the different
> -         function keys, wireless LED, LCD backlight level, and
> -         sometimes provides a "performance_control" sysfs file to allow
> -         the performance level of the laptop to be changed.
> +         function keys, wireless LED, LCD backlight level.
> +
> +         It may also provides some sysfs files described in

If you are resending this anyway:
"provide"

> +         <file:Documentation/ABI/testing/sysfs-platform-samsung-laptop>
>
>          To compile this driver as a module, choose M here: the module
>          will be called samsung-laptop.
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Cheers
David
