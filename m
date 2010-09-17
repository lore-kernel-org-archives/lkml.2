Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0IQWsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:48:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19449 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0IQWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:48:12 -0400
Message-ID: <4C93EFF6.5050806@kernel.org>
Date: Fri, 17 Sep 2010 15:47:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: memblock vs early_res
References: <4C93D3F0.3030307@goop.org>
In-Reply-To: <4C93D3F0.3030307@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 01:47 PM, Jeremy Fitzhardinge wrote:
>  Hi Yinghai,
> 
> I have the patch below floating around in my tree to make sure that
> early-reserved highmem is honoured when freeing unreserved memory.  I
> was trying to rebase it to current linux-next and noticed that all the
> early_res stuff has been replaced with memblock.
> 
> Is this still an issue?  What would the memblock version of this patch
> look like?
> 

Not sure why this patch is needed.

For the early reserve ranges, that could be overlapped with high pages, is "KVA RAM",
but We do remove those range in active ranges array. [ in calculate_numa_remap_pages() ].
[
...
                memblock_x86_reserve_range(node_kva_final,
                              node_kva_final+(((u64)size)<<PAGE_SHIFT),
                              "KVA RAM");

                node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
                remove_active_range(nid, node_remap_start_pfn[nid],
                                         node_remap_start_pfn[nid] + size);
...
]

Can you check if Gianluca Guida still can duplicate the problem that will need his patch ?

Thanks

Yinghai Lu
