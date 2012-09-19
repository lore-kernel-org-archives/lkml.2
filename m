Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2ISIeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2ISIeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:34:02 -0400
Message-ID: <50598342.8060407@redhat.com>
Date: Wed, 19 Sep 2012 05:33:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] linux/kernel.h: Fix warning seen with W=1 due to change
 in DIV_ROUND_CLOSEST
References: <1348027209-29710-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1348027209-29710-1-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-09-2012 01:00, Guenter Roeck escreveu:
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

It is great to have this warning disappearing.

Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
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
> 

