Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2KGUOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:14:10 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38557 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2KGUOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:14:07 -0500
Message-ID: <509AC0C4.4030704@linux.vnet.ibm.com>
Date: Thu, 08 Nov 2012 01:42:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, mjg59@srcf.ucam.org,
        paulmck@linux.vnet.ibm.com, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, arjan@linux.intel.com,
        kmpark@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, amit.kachhap@linaro.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] mm: Introduce memory regions data-structure to
 capture region boundaries within node
References: <20121106195026.6941.24662.stgit@srivatsabhat.in.ibm.com> <20121106195225.6941.2868.stgit@srivatsabhat.in.ibm.com> <50999755.4000209@linux.vnet.ibm.com>
In-Reply-To: <50999755.4000209@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110720-7014-0000-0000-000002282B64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 04:33 AM, Dave Hansen wrote:
> On 11/06/2012 11:52 AM, Srivatsa S. Bhat wrote:
>> But of course, memory regions are sub-divisions *within* a node, so it makes
>> sense to keep the data-structures in the node's struct pglist_data. (Thus
>> this placement makes memory regions parallel to zones in that node).
> 
> I think it's pretty silly to create *ANOTHER* subdivision of memory
> separate from sparsemem.  One that doesn't handle large amounts of
> memory or scale with memory hotplug.  As it stands, you can only support
> 256*512MB=128GB of address space, which seems pretty puny.
> 
> This node_regions[]:
> 
>> @@ -687,6 +698,8 @@ typedef struct pglist_data {
>>  	struct zone node_zones[MAX_NR_ZONES];
>>  	struct zonelist node_zonelists[MAX_ZONELISTS];
>>  	int nr_zones;
>> +	struct node_mem_region node_regions[MAX_NR_REGIONS];
>> +	int nr_node_regions;
>>  #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
>>  	struct page *node_mem_map;
>>  #ifdef CONFIG_MEMCG
> 
> looks like it's indexed the same way regardless of which node it is in.
>  In other words, if there are two nodes, at least half of it is wasted,
> and 3/4 if there are four nodes.  That seems a bit suboptimal.
> 

You're right, I have not addressed that problem in this initial RFC. Thanks
for pointing it out! Going forward, we can surely optimize the way we deal
with memory regions on NUMA systems, using some of the sparsemem techniques.

> Could you remind us of the logic for leaving sparsemem out of the
> equation here?
> 

Nothing, its just that in this first RFC I was more focussed towards getting
the overall design right, in terms of having an acceptable way of tracking
pages belonging to different regions within the page allocator (freelists)
and using it to influence page allocation decisions. And also to compare
the merits of this approach over the previous "Hierarchy" design, in a broad
("big picture") sense.

I'll add the above point you raised in my todo-list and address it in
subsequent versions of the patchset.

Thank you very much for the quick feedback!
 
Regards,
Srivatsa S. Bhat

