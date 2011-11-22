Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1KVJXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:23:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab1KVJXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
	<1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
Date: Tue, 22 Nov 2011 10:23:06 +0100
Message-ID: <CACRpkdadvJN2P-imOmNFMiYHTh6Vkoadbd4SEyWNQi76kAoVUw@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro module_platform_driver()
From: Linus Walleij <linus.walleij@linaro.org>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:00 AM, JJ Ding <jj_ding@emc.com.tw> wrote:

> Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
> save some platform_driver boilerplate code. Use it.
>
> Signed-off-by: JJ Ding <dgdunix@gmail.com>
(...)
> diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
> index fcdec5e..6c4828f 100644
> --- a/drivers/input/keyboard/nomadik-ske-keypad.c
> +++ b/drivers/input/keyboard/nomadik-ske-keypad.c
> @@ -390,18 +390,7 @@ struct platform_driver ske_keypad_driver = {
>        .probe = ske_keypad_probe,
>        .remove = __devexit_p(ske_keypad_remove),
>  };
> -
> -static int __init ske_keypad_init(void)
> -{
> -       return platform_driver_probe(&ske_keypad_driver, ske_keypad_probe);
> -}
> -module_init(ske_keypad_init);
> -
> -static void __exit ske_keypad_exit(void)
> -{
> -       platform_driver_unregister(&ske_keypad_driver);
> -}
> -module_exit(ske_keypad_exit);
> +module_platform_driver(ske_keypad_driver);
>
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Naveen Kumar <naveen.gaddipati@stericsson.com> / Sundar Iyer <sundar.iyer@stericsson.com>");

This actually also fixes a bug since platform_driver_probe() was used even
though there is a .probe member in the driver struct, so thanks.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
