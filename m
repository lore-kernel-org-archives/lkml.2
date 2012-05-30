Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2E3JWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:22:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51108 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab2E3JWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:22:33 -0400
Message-ID: <4FC5F309.9080604@gmail.com>
Date: Wed, 30 May 2012 18:14:33 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: linux@arm.linux.org.uk, b-cousson@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rnayak@ti.com, tony@atomide.com,
        wim@iguana.be, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 0/3] omap3/omap4: add device tree support for wdt
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <4FC50BA2.4070404@ti.com>
In-Reply-To: <4FC50BA2.4070404@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Hunter wrote:
> Hi Xiao Jiang,
>
> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>   
>> From: Xiao Jiang <jgq516@gmail.com>
>>
>> This series can be applied to dt branch of linux-omap tree.
>>     
>
> Thanks for sending this!
>
>   
>> Since omap24xx series has different wdt base addr (omap2420: 0x48022000 and
>> omap2430: 0x49016000) per commit 2817142f31bfbf26c216bf4f9192540c81b2d071, so
>> I don't add wdt node in omap2.dtsi just like omap3 and omap4, maybe different
>> dts files are needed for omap2420 and omap2430.
>>     
>
> Good point. I am wondering if we can simple drop the address from the
> wdt2 node for omap2. It is not really being used. May be Benoit can comment.
>
>   
Hmm, I think the address doesn't need anymore since the related hw_mod 
has the right addr as follows.

static struct omap_hwmod_addr_space omap2420_wd_timer2_addrs[] = {
        {  
                .pa_start       = 0x48022000,
                .pa_end         = 0x4802207f,
                .flags          = ADDR_TYPE_RT
        }, 
        { }
};

static struct omap_hwmod_addr_space omap2430_wd_timer2_addrs[] = {
        {  
                .pa_start       = 0x49016000,
                .pa_end         = 0x4901607f,
                .flags          = ADDR_TYPE_RT
        }, 
        { }
};

static struct omap_hwmod_addr_space omap3xxx_wd_timer2_addrs[] = {
        {   
                .pa_start       = 0x48314000,
                .pa_end         = 0x4831407f,
                .flags          = ADDR_TYPE_RT
        },  
        { } 
};

static struct omap_hwmod_addr_space omap44xx_wd_timer2_addrs[] = {
        {   
                .pa_start       = 0x4a313000,
                .pa_end         = 0x4a31407f,
                .flags          = ADDR_TYPE_RT
        },  
        { } 
};

Regards,
Xiao
> Cheers
> Jon

