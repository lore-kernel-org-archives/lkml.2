Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0LARL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:11:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62667 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab0LARL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v5cdDeleRb37eZweaxOeuhDQQdSIK37CfdL2yvMVXxDRWu1PST3Kkqmqxvp5HhTaWo
         SgF0Zl9X4BuB4Y7+B1SB0ppyVUpYJL9b7CL6Uz+Kru6fnhoq2n/ouFnWULgjpaz7QvYy
         H0xpAX7T/7xVm44uq2XD3LPZYmZj4g4OunWso=
Date: Wed, 1 Dec 2010 09:11:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kratochvil <honza@jikos.cz>
Subject: Re: [PATCH 2/2] Input: xpad - sanitize xpad_led_disconnect()
Message-ID: <20101201171114.GA11196@core.coreip.homeip.net>
References: <1291215874-5625-1-git-send-email-namhyung@gmail.com>
 <1291215874-5625-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291215874-5625-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On Thu, Dec 02, 2010 at 12:04:34AM +0900, Namhyung Kim wrote:
> IMHO kfree() here looks very confusing. xpad_led->name is an array
> of char inside struct xpad_led and is not a dynamic memory itself.
> But kfree() works well because it is a first member of the struct
> so it points start address of the struct and frees the struct.

This has already been fixed in my tree, thanks.

> 
> Change it to xpad_led for the correctness & readability and make
> xpad->led NULL for the safety.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Jan Kratochvil <honza@jikos.cz>
> ---
>  drivers/input/joystick/xpad.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index f885902..1ca49e8 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -728,7 +728,8 @@ static void xpad_led_disconnect(struct usb_xpad *xpad)
>  
>  	if (xpad_led) {
>  		led_classdev_unregister(&xpad_led->led_cdev);
> -		kfree(xpad_led->name);
> +		kfree(xpad_led);
> +		xpad->led = NULL;
>  	}
>  }
>  #else
> -- 
> 1.7.0.4
> 

-- 
Dmitry
