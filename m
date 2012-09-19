Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2ISL0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:26:41 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:25500 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2ISL0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:26:36 -0400
Date: Wed, 19 Sep 2012 13:26:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] linux/kernel.h: Fix warning seen with W=1 due to change
 in DIV_ROUND_CLOSEST
Message-ID: <20120919132622.672336ac@endymion.delvare>
In-Reply-To: <1348027209-29710-1-git-send-email-linux@roeck-us.net>
References: <1348027209-29710-1-git-send-email-linux@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012 21:00:09 -0700, Guenter Roeck wrote:
> After commit b6d86d3d (Fix DIV_ROUND_CLOSEST to support negative dividends),
> the following warning is seen if the kernel is compiled with W=1 (-Wextra):
> 
> warning: comparison of unsigned expression >= 0 is always true
> 
> The warning is due to the test '((typeof(x))-1) >= 0', which is used to detect
> if the variable type is unsigned. Research on the web suggests that the warning
> disappears if '>' instead of '>=' is used for the comparison.
> 
> Tests after changing the macro along that line show that the warning is gone,
> and that the result is still correct:
> 
> i=-4: DIV_ROUND_CLOSEST(i, 2)=-2
> i=-3: DIV_ROUND_CLOSEST(i, 2)=-2
> i=-2: DIV_ROUND_CLOSEST(i, 2)=-1
> i=-1: DIV_ROUND_CLOSEST(i, 2)=-1
> i=0: DIV_ROUND_CLOSEST(i, 2)=0
> i=1: DIV_ROUND_CLOSEST(i, 2)=1
> i=2: DIV_ROUND_CLOSEST(i, 2)=1
> i=3: DIV_ROUND_CLOSEST(i, 2)=2
> i=4: DIV_ROUND_CLOSEST(i, 2)=2
> 
> Code size is the same as before.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  include/linux/kernel.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 594b419..2451f1f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -91,7 +91,7 @@
>  {							\
>  	typeof(x) __x = x;				\
>  	typeof(divisor) __d = divisor;			\
> -	(((typeof(x))-1) >= 0 || (__x) >= 0) ?		\
> +	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
>  		(((__x) + ((__d) / 2)) / (__d)) :	\
>  		(((__x) - ((__d) / 2)) / (__d));	\
>  }							\

Very nice. Let's push this upstream ASAP.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
