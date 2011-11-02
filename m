Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1KBXVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:21:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46625 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1KBXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:21:08 -0400
Message-ID: <4EB1D05B.6020605@gmail.com>
Date: Thu, 03 Nov 2011 00:20:59 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
References: <4EB1CA4F.3090403@gmail.com> <20111102.190955.1902322759075682192.davem@davemloft.net> <4EB1CEC4.3090909@gmail.com> <20111102.191716.1682282796914825621.davem@davemloft.net> <20111102231917.GN31337@atomide.com>
In-Reply-To: <20111102231917.GN31337@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 00:19, Tony Lindgren wrote:

> * David Miller <davem@davemloft.net> [111102 15:42]:
>> c> 
>>> The issue is calculation of skb->end, which is based upon calculated
>>> 'size' variable.
>>>
>>> skb->end determines alignment of skb_shared_info, which is where the
>>> alignment problem is occuring for Tony.
>>
>> Right, and SMP_CACHE_BYTES setting should save us in any case.
>>
>> For ARM, SMP_CACHE_BYTES seems to be set to L1_CACHE_BYTES which in
>> turn is set via ARM_L1_CACHE_SHIFT which can be set seemingly to any
>> value but the defaults are 5 and 6 which should be OK.
>>
>> So unless Tony is using a non-standard setting of ARM_L1_CACHE_SHIFT,
>> this report is a bit mysterious.
> 
> This is happening at least with omap1_defconfig. In that case we have
> ARM_L1_CACHE_SHIFT=5.
> 
> Regards,
> 
> Tony


Do you use SLOB, SLUB or SLAB ?

Thanks

