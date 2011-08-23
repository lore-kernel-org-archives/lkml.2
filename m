Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1HWQmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:42:09 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4651 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1HWQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:42:01 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4E53D84F.5060604@broadcom.com>
Date: Tue, 23 Aug 2011 09:41:51 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624
 Thunderbird/5.0
MIME-Version: 1.0
To: "Maxin B. John" <maxin.john@gmail.com>
cc: "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: mach-bcmring: fix build error in core.c
References: <20110823111824.GA2806@maxin>
In-Reply-To: <20110823111824.GA2806@maxin>
X-WSS-ID: 624D062F3W47920361-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2011 4:18 AM, Maxin B. John wrote:
> CC      arch/arm/mach-bcmring/core.o
> arch/arm/mach-bcmring/core.c: In function 'bcmring_init_timer':
> arch/arm/mach-bcmring/core.c:238: error: implicit declaration of
> function 'sp804_clockevents_register'
> make[1]: *** [arch/arm/mach-bcmring/core.o] Error 1
> make: *** [arch/arm/mach-bcmring] Error 2
>
> Please let me know your comments on this fix:
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
> index 43eadbc..430da12 100644
> --- a/arch/arm/mach-bcmring/core.c
> +++ b/arch/arm/mach-bcmring/core.c
> @@ -235,7 +235,7 @@ void __init bcmring_init_timer(void)
>   	 */
>   	bcmring_clocksource_init();
>
> -	sp804_clockevents_register(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
> +	sp804_clockevents_init(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
>   }
>
>   struct sys_timer bcmring_timer = {
>
Signed-off-by: Jiandong Zheng <jdzheng@broadcom.com>

The same changes was in my comments on May 17 to Russell's serial 
patches to convert to sp804 clk dev, but seems it got lost.


