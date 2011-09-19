Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1ISXFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:05:43 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:2166 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1ISXFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:05:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1316473540!1369553!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Date: Mon, 19 Sep 2011 18:05:36 -0500
Subject: RE: [PATCH] arch/x86/mm/numa.c: quiet sparse noise when
 CONFIG_X86_64 is not set
Thread-Topic: [PATCH] arch/x86/mm/numa.c: quiet sparse noise when
 CONFIG_X86_64 is not set
Thread-Index: AcxwHxHo4JtfOTcqTwKlHpenY7NHBwHAVJZQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DAED66C@AUSP01VMBX24.collaborationhost.net>
References: <201109091638.49186.hartleys@visionengravers.com>
 <alpine.DEB.2.00.1109100238110.17756@chino.kir.corp.google.com>
 <20110911010619.GG29319@htj.dyndns.org>
In-Reply-To: <20110911010619.GG29319@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 10, 2011 6:06 PM, Tejun Heo wrote:
> Hello,
>
> On Sat, Sep 10, 2011 at 02:39:02AM -0700, David Rientjes wrote:
>> On Fri, 9 Sep 2011, H Hartley Sweeten wrote:
>> 
>>> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
>>> index fbeaaf4..11c60a7 100644
>>> --- a/arch/x86/mm/numa.c
>>> +++ b/arch/x86/mm/numa.c
>>> @@ -455,6 +455,7 @@ void __init numa_set_distance(int from, int to, int distance)
>>>  	numa_distance[from * numa_distance_cnt + to] = distance;
>>>  }
>>>  
>>> +#ifdef CONFIG_X86_64
>>>  int __node_distance(int from, int to)
>>>  {
>>>  	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
>>> @@ -462,6 +463,7 @@ int __node_distance(int from, int to)
>>>  	return numa_distance[from * numa_distance_cnt + to];
>>>  }
>>>  EXPORT_SYMBOL(__node_distance);
>>> +#endif
>>>  
>>>  /*
>>>   * Sanity check to catch more bad NUMA configurations (they are amazingly
>>> 
>>
>> What is 64-bit specific about this function?  Shouldn't we be defining it 
>> to be node_distance for all of x86?
>
> Yeap, that's a remnant of the old separate code paths, which wasn't
> discovered because asm-generic/topology.h defines fallback
> node_distance() automatically.  We should drop #ifdef from
> arch/x86/include/asm/topology.h::node_distance().  Hartley, can you
> please send a patch to do that?

Tejun,

I just posted the new patch, "x86: use the same node distance for 32 and 64-bit".

Thanks,
Hartley