Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab1FLMLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 08:11:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab1FLMLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 08:11:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal Time to the printk.
Date: Sun, 12 Jun 2011 14:12:09 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
References: <1307599301-2524-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1307599301-2524-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121412.09903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, June 09, 2011, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed 
> wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
> "UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!
> 
> before:
> [    0.114915] Time:  1:47:03  Date: 06/09/11
> 
> after:
> [    0.114728] Time:  5:46:02 UTC Date: 06/09/11
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

I suspect the goal is to mark messages printed by the PM trace code so that
they can be easily distinguished from messages from other sources to avoid
confusion.  Why do you think it's a good idea to use the "UTC" string for
this purpose?  The time printed in those messages need not be UTC.

It would be better to simply print "RTC time: ..., date: ..." IMO.

Thanks,
Rafael


> ---
>  drivers/base/power/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> index c80e138..009f459 100644
> --- a/drivers/base/power/trace.c
> +++ b/drivers/base/power/trace.c
> @@ -112,7 +112,7 @@ static unsigned int read_magic_time(void)
>  	unsigned int val;
>  
>  	get_rtc_time(&time);
> -	pr_info("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
> +	pr_info("Time: %2d:%02d:%02d UTC Date: %02d/%02d/%02d\n",
>  		time.tm_hour, time.tm_min, time.tm_sec,
>  		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
>  	val = time.tm_year;				/* 100 years */
> 

