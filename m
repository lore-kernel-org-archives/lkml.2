Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0IFDu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 23:50:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51990 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0IFDu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 23:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ci1ZNqHBCYRjAE82dV7FngIdIEHYwzEa9jN+StZUgBm0nSYAEQDcpFh+ctQ0CMLU/c
         cf5GQlbbHe6y0evyph9Zs6nmU1xFU2+/V5AJlFy9RxHj33VJ3gIsvG44TUYDj3G3nmen
         CYYSO38mvqNTOAtSvJ6inAOfusdYf8kJCb11o=
MIME-Version: 1.0
In-Reply-To: <1283700790-3558-1-git-send-email-mark.brown314@gmail.com>
References: <1283700790-3558-1-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 6 Sep 2010 11:50:07 +0800
Message-ID: <AANLkTi=9tbLYZO7QPCBiEeUTeedz+wuaAWanEuY4CSO2@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa27x_keypad: added a comment to explain
 clear_wakeup_event callback
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: grinberg@compulab.co.il, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, haojian.zhuang@marvell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 5, 2010 at 11:33 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/plat-pxa/include/plat/pxa27x_keypad.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
> index 73dacda..abcc36e 100644
> --- a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
> +++ b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
> @@ -25,6 +25,13 @@
>  *
>  * 4. matrix key and direct key will use the same debounce_interval by
>  *    default, which should be sufficient in most cases
> + *
> + * pxa168 keypad platform specific parameter
> + *
> + * NOTE:
> + * clear_wakeup_event callback is a workaround required to clear the
> + * keypad interrupt. The keypad wake must be cleared in addition to
> + * reading the MI/DI bits in the KPC register.
>  */
>  struct pxa27x_keypad_platform_data {
>
> @@ -52,6 +59,8 @@ struct pxa27x_keypad_platform_data {
>
>        /* key debounce interval */
>        unsigned int    debounce_interval;
> +
> +       /* clear wakeup event requirement for pxa168 */
>        void            (*clear_wakeup_event)(void);
>  };
>
> --
> 1.7.0.4
>
>

Merged into below commit, and 'devel' branch pushed.

  ARM: pxa27x_keypad: added wakeup event handler for keypad interrupts

Thanks.
