Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2JRIyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:54:15 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60475 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab2JRIyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:54:13 -0400
Message-ID: <50803433.4000904@parallels.com>
Date: Thu, 18 Oct 2012 20:54:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 01/14] memcg: Make it possible to use the stock for
 more than one page.
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-2-git-send-email-glommer@parallels.com> <20121017151155.d417bd13.akpm@linux-foundation.org>
In-Reply-To: <20121017151155.d417bd13.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 02:11 AM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 14:16:38 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>>
>> We currently have a percpu stock cache scheme that charges one page at a
>> time from memcg->res, the user counter. When the kernel memory
>> controller comes into play, we'll need to charge more than that.
>>
>> This is because kernel memory allocations will also draw from the user
>> counter, and can be bigger than a single page, as it is the case with
>> the stack (usually 2 pages) or some higher order slabs.
>>
>> ...
>>
>> -/*
>> - * Try to consume stocked charge on this cpu. If success, one page is consumed
>> - * from local stock and true is returned. If the stock is 0 or charges from a
>> - * cgroup which is not current target, returns false. This stock will be
>> - * refilled.
>> +/**
>> + * consume_stock: Try to consume stocked charge on this cpu.
>> + * @memcg: memcg to consume from.
>> + * @nr_pages: how many pages to charge.
>> + *
>> + * The charges will only happen if @memcg matches the current cpu's memcg
>> + * stock, and at least @nr_pages are available in that stock.  Failure to
>> + * service an allocation will refill the stock.
>> + *
>> + * returns true if succesfull, false otherwise.
> 
> spello.
> 
Thanks. I can never successfuly write successfull =(

>>   */
>> -static bool consume_stock(struct mem_cgroup *memcg)
>> +static bool consume_stock(struct mem_cgroup *memcg, int nr_pages)
> 
> I don't believe there is a case for nr_pages < 0 here?  If not then I
> suggest that it would be clearer to use an unsigned type, like
> memcg_stock_pcp.stock.
> 

Done, thanks.

