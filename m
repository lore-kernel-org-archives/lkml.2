Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2HMIIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:08:48 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47144 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2HMIIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:08:45 -0400
Message-ID: <5028B552.2070708@parallels.com>
Date: Mon, 13 Aug 2012 12:05:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        "David Rientjes" <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        "Suleiman Souhlal" <suleiman@google.com>
Subject: Re: [PATCH v2 02/11] memcg: Reclaim when more than one page needed.
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-3-git-send-email-glommer@parallels.com> <20120810185417.GB16110@dhcp22.suse.cz>
In-Reply-To: <20120810185417.GB16110@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 10:54 PM, Michal Hocko wrote:
> On Thu 09-08-12 17:01:10, Glauber Costa wrote:
>> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>>
>> mem_cgroup_do_charge() was written before kmem accounting, and expects
>> three cases: being called for 1 page, being called for a stock of 32
>> pages, or being called for a hugepage.  If we call for 2 or 3 pages (and
>> both the stack and several slabs used in process creation are such, at
>> least with the debug options I had), it assumed it's being called for
>> stock and just retried without reclaiming.
>>
>> Fix that by passing down a minsize argument in addition to the csize.
>>
>> And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
>> needed at all (and presumably is since it's there, perhaps to handle
>> races), then it should be extended to more than PAGE_SIZE, yet how far?
>> And should there be a retry count limit, of what?  For now retry up to
>> COSTLY_ORDER (as page_alloc.c does) and make sure not to do it if
>> __GFP_NORETRY.
>>
>> [v4: fixed nr pages calculation pointed out by Christoph Lameter ]
>>
>> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I am not happy with the min_pages argument but we can do something more
> clever  later.
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 

I am a bit confused here. Does your ack come before or after your other
comments on this patch?


