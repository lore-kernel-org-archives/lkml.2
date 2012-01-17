Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2AQB4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:56:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38632 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2AQBz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120116184518.205969311@clark.kroah.org>
References: <20120116184527.GA11972@kroah.com>
	<20120116184518.205969311@clark.kroah.org>
Date: Mon, 16 Jan 2012 20:55:59 -0500
X-Google-Sender-Auth: F3MOxCSSBjcEViUCQYk4oGYmgdY
Message-ID: <CAP=VYLqajuhNY1S3e7Nbw4DiyEDL1uGthC8VswJ9zJxzwy+wOQ@mail.gmail.com>
Subject: Re: [29/48] HID: wiimote: Select INPUT_FF_MEMLESS
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 1:44 PM, Greg KH <gregkh@suse.de> wrote:
> 3.1-stable review patch.  If anyone has any objections, please let me know.

This one looks like typical patch Makefile/Kconfig "oh, hey this fits anywhere"
nonsense, and is completely broken.  Original was for a Wiimote, not Wacom.

P.

>
> ------------------
>
> From: David Herrmann <dh.herrmann@googlemail.com>
>
> commit ef6f41157f3864d9bf42671b2ed66062dcafb72e upstream.
>
> We depend on memless force-feedback support, therefore correctly select the
> related config options.
>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/hid/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -583,6 +583,7 @@ config HID_WACOM_POWER_SUPPLY
>        bool "Wacom Bluetooth devices power supply status support"
>        depends on HID_WACOM
>        select POWER_SUPPLY
> +       select INPUT_FF_MEMLESS
>        ---help---
>          Say Y here if you want to enable power supply status monitoring for
>          Wacom Bluetooth devices.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
