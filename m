Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2F0Iml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:42:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35145 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2F0Imi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:42:38 -0400
Message-ID: <4FEAC6DA.1010806@parallels.com>
Date: Wed, 27 Jun 2012 12:39:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH 00/11] kmem controller for memcg: stripped down version
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <alpine.DEB.2.00.1206261804160.11287@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206261804160.11287@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 05:08 AM, David Rientjes wrote:
> On Tue, 26 Jun 2012, Andrew Morton wrote:
>
>> mm, maybe.  Kernel developers tend to look at code from the point of
>> view "does it work as designed", "is it clean", "is it efficient", "do
>> I understand it", etc.  We often forget to step back and really
>> consider whether or not it should be merged at all.
>>
>
> It's appropriate for true memory isolation so that applications cannot
> cause an excess of slab to be consumed.  This allows other applications to
> have higher reservations without the risk of incurring a global oom
> condition as the result of the usage of other memcgs.

Just a note for Andrew, we we're in the same page: The slab cache 
limitation is not included in *this* particular series. The goal was 
always to have other kernel resources limited as well, and the general 
argument from David holds: we want a set of applications to run truly 
independently from others, without creating memory pressure on the 
global system.

The way history develop in this series, I started from the slab cache, 
and a page-level tracking appeared on that series. I then figured it 
would be better to start tracking something that is totally page-based, 
such as the stack - that already accounts for 70 % of the 
infrastructure, and then merge the slab code later. In this sense, it 
was just a strategy inversion. But both are, and were, in the goals.

> I'm not sure whether it would ever be appropriate to limit the amount of
> slab for an individual slab cache, however, instead of limiting the sum of
> all slab for a set of processes.  With cache merging in slub this would
> seem to be difficult to do correctly.

Yes, I do agree.



