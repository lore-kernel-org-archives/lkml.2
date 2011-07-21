Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1GUHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:18:29 -0400
Received: from relay.parallels.com ([195.214.232.42]:53427 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1GUHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:18:26 -0400
Message-ID: <4E27D2BD.8060002@parallels.com>
Date: Thu, 21 Jul 2011 11:18:21 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
References: <20110720121612.28888.38970.stgit@localhost6>	 <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>	 <alpine.DEB.2.00.1107200854390.32737@router.home>	 <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <alpine.DEB.2.00.1107200950270.1472@router.home>	 <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <alpine.DEB.2.00.1107201033080.1472@router.home>	 <1311177362.2338.57.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <alpine.DEB.2.00.1107201114480.1472@router.home>	 <1311179465.2338.62.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <1311181463.2338.72.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <alpine.DEB.2.00.1107201212140.1472@router.home>	 <alpine.DEB.2.00.1107202028050.2847@tiger>	 <alpine.DEB.2.00.1107201237190.1472@router.home>	 <alpine.DEB.2.00.1107202040240.2847@tiger> <1311185224.14555.43.camel@calx>
In-Reply-To: <1311185224.14555.43.camel@calx>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, 2011-07-20 at 20:41 +0300, Pekka Enberg wrote:
>> On Wed, 20 Jul 2011, Pekka Enberg wrote:
>>>> On Wed, 20 Jul 2011, Eric Dumazet wrote:
>>>>>> [PATCH v2] slab: shrinks sizeof(struct kmem_cache)
>>>>
>>>> On Wed, 20 Jul 2011, Christoph Lameter wrote:
>>>>> This will solve the issue for small nr_cpu_ids but those with 4k cpus will
>>>>> still have the issue.
>>>>>
>>>>> Acked-by: Christoph Lameter<cl@linux.com>
>>>>
>>>> Applied, thanks! Do we still want the __GFP_REPEAT patch from Konstantin
>>>> though?
>>
>> On Wed, 20 Jul 2011, Christoph Lameter wrote:
>>> Those with 4k cpus will be thankful I guess.
>>
>> OTOH, I'm slightly worried that it might mask a real problem
>> with GFP_KERNEL not being aggressive enough. Mel?
>
> I think that's already been demonstrated here, yes. It's just waiting
> for another obscure workload to trigger it.
>

I Agree, __GFP_REPEAT doesn't fix the problem completely. So, some more detailed investigation required.
My case is not very honest, because my kernel has slightly different memory controller, and it has bugs for sure.
