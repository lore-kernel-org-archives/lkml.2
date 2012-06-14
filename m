Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2FNCji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:39:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47985 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2FNCjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:39:36 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-82-4fd94ee69d73
Message-ID: <4FD94EE8.9030300@kernel.org>
Date: Thu, 14 Jun 2012 11:39:36 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.file-systems,gmane.linux.kernel
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com
Subject: Re: [PATCH] mm: add gfp_mask parameter to vm_map_ram()
References: <20120612012134.GA7706@localhost> <20120613123932.GA1445@localhost> <20120614012026.GL3019@devil.redhat.com> <20120614014902.GB7289@localhost> <4FD94779.3030108@kernel.org> <20120614022132.GA3766@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120614022132.GA3766@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 11:21 AM, Tejun Heo wrote:

> Hello, guys.
> 
> On Thu, Jun 14, 2012 at 11:07:53AM +0900, Minchan Kim wrote:
>> It shouldn't work because vmap_page_range still can allocate
>> GFP_KERNEL by pud_alloc in vmap_pud_range.  For it, I tried [1] but
>> other mm guys want to add WARNING [2] so let's avoiding gfp context
>> passing.
>>
>> [1] https://lkml.org/lkml/2012/4/23/77
>> [2] https://lkml.org/lkml/2012/5/2/340
> 
> Yeah, vmalloc area doesn't support !GFP_KERNEL allocations and as
> Minchan said, changing this would require updating page table
> allocation functions on all archs.  This is the same reason why percpu
> allocator doesn't support !GFP_KERNEL allocations which in turn made
> blk-throttle implement its own private percpu pool.
> 
> If xfs can't live without GFP_NOFS vmalloc allocations, either it has
> to implement its own pool or maybe it's time to implement !GFP_KERNEL
> allocs for vmalloc area.  I don't know.


There is another example in ARM. 
http://www.spinics.net/lists/arm-kernel/msg179202.html
They try to make pool for atomic vmalloc support. :(
Only GFP_KERNEL support vmalloc spreads out many pools in system, Sigh. 

-- 
Kind regards,
Minchan Kim
