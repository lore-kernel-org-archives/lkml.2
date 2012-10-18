Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2JRJhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:37:54 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36156 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2JRJhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:37:53 -0400
Message-ID: <507FCDE3.1050408@parallels.com>
Date: Thu, 18 Oct 2012 13:37:39 +0400
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
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 13/14] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-14-git-send-email-glommer@parallels.com> <20121017151245.f11c4d18.akpm@linux-foundation.org>
In-Reply-To: <20121017151245.f11c4d18.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 02:12 AM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 14:16:50 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> @@ -146,7 +146,7 @@ void __weak arch_release_thread_info(struct thread_info *ti)
>>  static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
>>  						  int node)
>>  {
>> -	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
>> +	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
>>  					     THREAD_SIZE_ORDER);
> 
> yay, we actually used all this code for something ;)
> 
Happy to be of use, sir!

> I don't think we really saw a comprehensive list of what else the kmem
> controller will be used for, but I believe that all other envisaged
> applications will require slab accounting, yes?
> 
> 
> So it appears that all we have at present is a
> yet-another-fork-bomb-preventer, but one which requires that the
> culprit be in a container?  That's reasonable, given your
> hosted-environment scenario.  It's unclear (to me) that we should merge
> all this code for only this feature.  Again, it would be good to have a
> clear listing of and plan for other applications of this code.
> 

I agree. This doesn't buy me much without slab accounting. But
reiterating what I've just said in another e-mail, slab accounting is
not really in plan stage, but had also been through extensive development.

As a matter of fact, it used to be only "slab accounting" in the
beginning, without this. I've split it more recently because I believe
it would allow people to do a more focused review, leading to better code.


