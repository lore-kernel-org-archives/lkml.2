Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab2J2LCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:02:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab2J2LCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:02:41 -0400
Message-ID: <508E624B.8020207@gmail.com>
Date: Mon, 29 Oct 2012 20:02:35 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: lm3639_bl: Fix up world writable sysfs file
References: <1351499898.14725.5.camel@phoenix>
In-Reply-To: <1351499898.14725.5.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012년 10월 29일 17:38, Axel Lin 쓴 글:
> We don't need the sysfs file to be world writable or group writable.
> This file is write-only, change it to S_IWUSR (0200).
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/video/backlight/lm3639_bl.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
> index 585949b..6f7a20e 100644
> --- a/drivers/video/backlight/lm3639_bl.c
> +++ b/drivers/video/backlight/lm3639_bl.c
> @@ -214,7 +214,7 @@ out_input:
>   
>   }
>   
> -static DEVICE_ATTR(bled_mode, 0666, NULL, lm3639_bled_mode_store);
> +static DEVICE_ATTR(bled_mode, S_IWUSR, NULL, lm3639_bled_mode_store);
>   
>   /* torch */
>   static void lm3639_torch_brightness_set(struct led_classdev *cdev,

It's also nice to us. Thank you Alex.
Acked-by: G.Shark Jeong<gshark.jeong@gmail.com>

