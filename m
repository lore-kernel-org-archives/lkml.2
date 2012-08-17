Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2HQCjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:39:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42457 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HQCjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:39:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <502DAEAA.4000805@jp.fujitsu.com>
Date: Fri, 17 Aug 2012 11:38:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <50253EA8.9080205@jp.fujitsu.com> <5028BCA3.6040506@parallels.com>
In-Reply-To: <5028BCA3.6040506@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/13 17:36), Glauber Costa wrote:
> On 08/10/2012 09:02 PM, Kamezawa Hiroyuki wrote:
>> (2012/08/09 22:01), Glauber Costa wrote:
>>> This patch adds the basic infrastructure for the accounting of the slab
>>> caches. To control that, the following files are created:
>>>
>>>    * memory.kmem.usage_in_bytes
>>>    * memory.kmem.limit_in_bytes
>>>    * memory.kmem.failcnt
>>>    * memory.kmem.max_usage_in_bytes
>>>
>>> They have the same meaning of their user memory counterparts. They
>>> reflect the state of the "kmem" res_counter.
>>>
>>> The code is not enabled until a limit is set. This can be tested by the
>>> flag "kmem_accounted". This means that after the patch is applied, no
>>> behavioral changes exists for whoever is still using memcg to control
>>> their memory usage.
>>>
>>> We always account to both user and kernel resource_counters. This
>>> effectively means that an independent kernel limit is in place when the
>>> limit is set to a lower value than the user memory. A equal or higher
>>> value means that the user limit will always hit first, meaning that kmem
>>> is effectively unlimited.
>>>
>>> People who want to track kernel memory but not limit it, can set this
>>> limit to a very high number (like RESOURCE_MAX - 1page - that no one
>>> will ever hit, or equal to the user memory)
>>>
>>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>>> CC: Michal Hocko <mhocko@suse.cz>
>>> CC: Johannes Weiner <hannes@cmpxchg.org>
>>> Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Could you add  a patch for documentation of this new interface and a text
>> explaining the behavior of "kmem_accounting" ?
>>
>> Hm, my concern is the difference of behavior between user page accounting and
>> kmem accounting...but this is how tcp-accounting is working.
>>
>> Once you add Documentation, it's okay to add my Ack.
>>
> I plan to add documentation in a separate patch. Due to that, can I add
> your ack to this patch here?
> 
> Also, I find that the description text in patch0 grew to be quite
> informative and complete. I plan to add that to the documentation
> if that is ok with you
> 

Ack to this patch.

-Kame


