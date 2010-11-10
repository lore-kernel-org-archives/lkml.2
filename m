Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0KJNKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:10:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0KJNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:10:51 -0500
Message-ID: <4CDA99D6.20702@monstr.eu>
Date: Wed, 10 Nov 2010 14:10:46 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 06/10] microblaze: convert to clocksource_register_hz/khz
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com> <1288642350-1599-7-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1288642350-1599-7-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:
> This converts the microblaze clocksources to use clocksource_register_hz/khz
> 
> This is untested, so any assistance in testing would be appreciated!
> 
> CC: Michal Simek <monstr@monstr.eu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/microblaze/kernel/timer.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)

I can't see any problem in it.

Tested-by: Michal Simek <monstr@monstr.eu>



> 
> diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
> index a5aa33d..68ec7d1 100644
> --- a/arch/microblaze/kernel/timer.c
> +++ b/arch/microblaze/kernel/timer.c
> @@ -217,16 +217,12 @@ static struct clocksource clocksource_microblaze = {
>  	.rating		= 300,
>  	.read		= microblaze_read,
>  	.mask		= CLOCKSOURCE_MASK(32),
> -	.shift		= 8, /* I can shift it */
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
>  static int __init microblaze_clocksource_init(void)
>  {
> -	clocksource_microblaze.mult =
> -			clocksource_hz2mult(timer_clock_freq,
> -						clocksource_microblaze.shift);
> -	if (clocksource_register(&clocksource_microblaze))
> +	if (clocksource_register_hz(&clocksource_microblaze, timer_clock_freq))
>  		panic("failed to register clocksource");
>  
>  	/* stop timer1 */


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
