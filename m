Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab2L0XIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:08:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44936 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0XIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:08:37 -0500
Message-ID: <50DCD4CB.50205@oracle.com>
Date: Thu, 27 Dec 2012 18:07:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even
 if slab is available
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-2-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com> <50DCCE5A.4000805@oracle.com> <alpine.DEB.2.00.1212271502070.23127@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212271502070.23127@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 06:04 PM, David Rientjes wrote:
> On Thu, 27 Dec 2012, Sasha Levin wrote:
> 
>> That's exactly what happens with the patch. Note that in the current upstream
>> version there are several slab checks scattered all over.
>>
>> In this case for example, I'm removing it from __alloc_bootmem_node(), but the
>> first code line of__alloc_bootmem_node_nopanic() is:
>>
>>         if (WARN_ON_ONCE(slab_is_available()))
>>                 return kzalloc(size, GFP_NOWAIT);
>>
> 
> You're only talking about mm/bootmem.c and not mm/nobootmem.c, and notice 
> that __alloc_bootmem_node() does not call __alloc_bootmem_node_nopanic(), 
> it calls ___alloc_bootmem_node_nopanic().

Holy cow, this is an underscore hell.


Thanks,
Sasha

