Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2L0Wot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:44:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0Wor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:44:47 -0500
Message-ID: <50DCCE98.70000@oracle.com>
Date: Thu, 27 Dec 2012 17:41:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm, sparse: allocate bootmem without panicing in
 sparse_mem_maps_populate_node
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212271422280.18214@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212271422280.18214@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 05:23 PM, David Rientjes wrote:
> On Sun, 23 Dec 2012, Sasha Levin wrote:
> 
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 6b5fb76..72a0db6 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -401,7 +401,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
>>  	}
>>  
>>  	size = PAGE_ALIGN(size);
>> -	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
>> +	map = __alloc_bootmem_node_high_nopanic(NODE_DATA(nodeid), size * map_count,
>>  					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
>>  	if (map) {
>>  		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
> 
> What tree is this series based on?  There's no 
> __alloc_bootmem_node_high_nopanic() either in 3.8-rc1 nor in linux-next.
> 

This is me getting git-send-email wrong and forgetting the first patch that adds it.

Sorry, will resend.


Thanks,
Sasha
