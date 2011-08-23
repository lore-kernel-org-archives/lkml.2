Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1HWQoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:44:20 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3545 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1HWQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:44:14 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E53D8D4.5080208@broadcom.com>
Date: Tue, 23 Aug 2011 09:44:04 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624
 Thunderbird/5.0
MIME-Version: 1.0
To: "Maxin B John" <maxin.john@gmail.com>
cc: "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: mach-bcmring: fix build error in dma.c
References: <20110823112128.GA2825@maxin>
In-Reply-To: <20110823112128.GA2825@maxin>
X-WSS-ID: 624D05CB4R01437744-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2011 4:21 AM, Maxin B John wrote:
>   CC      arch/arm/mach-bcmring/dma.o
> arch/arm/mach-bcmring/dma.c: In function 'dma_request_channel_dbg':
> arch/arm/mach-bcmring/dma.c:1022: error: 'TASK_INTERRUPTIBLE'
> undeclared (first use in this function)
> arch/arm/mach-bcmring/dma.c:1022: error: (Each undeclared identifier
> is reported only once
> arch/arm/mach-bcmring/dma.c:1022: error: for each function it appears
> in.)
> arch/arm/mach-bcmring/dma.c:1024: error: implicit declaration of
> function 'schedule'
> arch/arm/mach-bcmring/dma.c:1027: error: implicit declaration of
> function 'signal_pending'
> arch/arm/mach-bcmring/dma.c: In function 'dma_free_channel':
> arch/arm/mach-bcmring/dma.c:1092: error: 'TASK_INTERRUPTIBLE'
> undeclared (first use in this function)
> arch/arm/mach-bcmring/dma.c: In function 'dma_map_add_region':
> arch/arm/mach-bcmring/dma.c:1946: error: dereferencing pointer to
> incomplete type
> arch/arm/mach-bcmring/dma.c:1948: error: dereferencing pointer to
> incomplete type
> arch/arm/mach-bcmring/dma.c:1955: error: dereferencing pointer to
> incomplete type
> make[1]: *** [arch/arm/mach-bcmring/dma.o] Error 1
> make: *** [arch/arm/mach-bcmring] Error 2
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
> index 0ca0005..12d1504 100644
> --- a/arch/arm/mach-bcmring/dma.c
> +++ b/arch/arm/mach-bcmring/dma.c
> @@ -35,6 +35,7 @@
>   #include<linux/mm.h>
>   #include<linux/pfn.h>
>   #include<linux/atomic.h>
> +#include<linux/sched.h>
>   #include<mach/dma.h>
>
>   /* I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled */
>
Signed-off-by: Jiandong Zheng <jdzheng@broadcom.com>

I have same fix submitted on May 12, which was supposed to be applied 
soon but seems it wasn't.

