Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1GTOry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:47:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:38702 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1GTOrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:47:53 -0400
Message-ID: <4E26EA93.5020302@parallels.com>
Date: Wed, 20 Jul 2011 18:47:47 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
References: <20110720121612.28888.38970.stgit@localhost6>	 <alpine.DEB.2.00.1107201611010.3528@tiger> <4E26D7EA.3000902@parallels.com>	 <alpine.DEB.2.00.1107201638520.4921@tiger>	 <alpine.DEB.2.00.1107200852590.32737@router.home>	 <20110720142018.GL5349@suse.de>  <4E26E705.8050704@parallels.com> <1311172859.2338.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1311172859.2338.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le mercredi 20 juillet 2011 à 18:32 +0400, Konstantin Khlebnikov a
> écrit :
>
>> I catch this on our rhel6-openvz kernel, and yes it very patchy,
>> but I don't see any reasons why this cannot be reproduced on mainline kernel.
>>
>> there was abount ten containers with random stuff, node already do intensive swapout but still alive,
>> in this situation starting new containers sometimes (1 per 1000) fails due to kmem_cache_create failures in nf_conntrack,
>> there no other messages except:
>> Unable to create nf_conn slab cache
>> and some
>> nf_conntrack: falling back to vmalloc.
>> (it try allocates huge hash table and do it via vmalloc if kmalloc fails)
>
>
> Does this kernel contain commit 6d4831c2 ?
> (vfs: avoid large kmalloc()s for the fdtable)
>

yes, but not exactly, in our kerner it looks like:

static inline void * alloc_fdmem(unsigned int size)
{
	if (size <= PAGE_SIZE)
		return kmalloc(size, GFP_KERNEL);
	else
		return vmalloc(size);
}

and looks like this change is came from ancient times =)
