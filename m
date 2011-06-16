Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1FPOjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:39:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52059 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1FPOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:39:09 -0400
Message-ID: <4DFA1523.2060103@ru.mvista.com>
Date: Thu, 16 Jun 2011 18:37:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
CC: Duncan Sands <duncan.sands@free.fr>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 07/11] drivers/usb/atm: use printk_ratelimited() instead
 of printk_ratelimit()
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de> <98558b2a3dbb8b14a3bc90e0a73ca7d61dd10a53.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
In-Reply-To: <98558b2a3dbb8b14a3bc90e0a73ca7d61dd10a53.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Zerpies wrote:

> Since printk_ratelimit() shouldn't be used anymore (see comment in
> include/linux/printk.h), replace it with printk_ratelimited()

> Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
> ---
>  drivers/usb/atm/usbatm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
> index 989e16e..d3448ca 100644
> --- a/drivers/usb/atm/usbatm.c
> +++ b/drivers/usb/atm/usbatm.c
> @@ -81,6 +81,7 @@
>  #include <linux/timer.h>
>  #include <linux/wait.h>
>  #include <linux/kthread.h>
> +#include <linux/ratelimit.h>
>  
>  #ifdef VERBOSE_DEBUG
>  static int usbatm_print_packet(const unsigned char *data, int len);
> @@ -668,8 +669,7 @@ static int usbatm_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
>  	/* racy disconnection check - fine */
>  	if (!instance || instance->disconnected) {
>  #ifdef DEBUG
> -		if (printk_ratelimit())
> -			printk(KERN_DEBUG "%s: %s!\n", __func__, instance ? "disconnected" : "NULL instance");
> +		printk_ratelimited(KERN_DEBUG "%s: %s!\n", __func__, instance ? "disconnected" : "NULL instance");
>  #endif

    You could use pr_debug_ratelimited() and eliminate #ifdef with that.

WBR, Sergei

