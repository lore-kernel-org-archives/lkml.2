Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2AaVkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:40:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38091 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2AaVkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:40:43 -0500
MIME-Version: 1.0
In-Reply-To: <201201312224.46360.heiko@sntech.de>
References: <201201312224.46360.heiko@sntech.de>
Date: Tue, 31 Jan 2012 13:40:42 -0800
X-Google-Sender-Auth: _idmCVu_vEn_JQbmaWklbGNgVHw
Message-ID: <CAPz4a6DDwt2uEX1o3ULSESjnVqMA1gBWoFP27XCviaOXd1-fpw@mail.gmail.com>
Subject: Re: [PATCH] Input: evdev - fix variable initialisation
From: Dima Zavin <dima@android.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ugh, thanks for fixing this.

On Tue, Jan 31, 2012 at 1:24 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Commit 509f87c5f564 (evdev - do not block waiting for an event if fd
> is nonblock) created a code path were it was possible to use retval
> uninitialized.
>
> This could lead to the xorg evdev input driver getting corrupt data
> and refusing to work with log messages like
>        AUO-Pixcir touchscreen: Read error: Success
>        sg060_keys: Read error: Success
>        AUO-Pixcir touchscreen: Read error: Success
>        sg060_keys: Read error: Success
> (for drivers auo-pixcir-ts and gpio-keys).
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Dima Zavin <dima@android.com>

> ---
> This is obviously meant as a fix for 3.3
>
>  drivers/input/evdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 76457d5..afc166f 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -386,7 +386,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
>        struct evdev_client *client = file->private_data;
>        struct evdev *evdev = client->evdev;
>        struct input_event event;
> -       int retval;
> +       int retval = 0;
>
>        if (count < input_event_size())
>                return -EINVAL;
> --
> 1.7.2.3
