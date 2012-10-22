Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2JVKOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:14:01 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36757 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2JVKN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:13:59 -0400
Message-ID: <50851C54.9080600@parallels.com>
Date: Mon, 22 Oct 2012 14:13:40 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 10/18] sl[au]b: always get the cache from its page
 in kfree
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-11-git-send-email-glommer@parallels.com> <0000013a7a8e764d-5cef2c85-993f-4600-85c7-ce3fe137f16f-000000@email.amazonses.com>
In-Reply-To: <0000013a7a8e764d-5cef2c85-993f-4600-85c7-ce3fe137f16f-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:44 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> struct page already have this information. If we start chaining
>> caches, this information will always be more trustworthy than
>> whatever is passed into the function
> 
> Yes it does but the information is not standardized between the allocators
> yet. Coul you unify that? Come out with a struct page overlay that is as
> much the same as possible. Then kfree can also be unified because the
> lookup is always the same. That way you can move kfree into slab_common
> and avoid modifying multiple allocators.
> 

Ok, this is yet another changelog mistake from mine. This function is
not about kfree, but kmem_cache_free.

But part of your comment still applies, the page lookup can still be
common. I will take a look at that.

