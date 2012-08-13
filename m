Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2HMIEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:04:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49823 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2HMIEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:04:33 -0400
Message-ID: <5028B450.9080309@parallels.com>
Date: Mon, 13 Aug 2012 12:01:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <50254A0A.3080805@jp.fujitsu.com>
In-Reply-To: <50254A0A.3080805@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 09:51 PM, Kamezawa Hiroyuki wrote:
>> +		/*
>> +		 * Once enabled, can't be disabled. We could in theory disable
>> +		 * it if we haven't yet created any caches, or if we can shrink
>> +		 * them all to death. But it is not worth the trouble
>> +		 */
>>   		static_key_slow_inc(&memcg_kmem_enabled_key);
>> -		memcg->kmem_accounted = true;
>> +
>> +		if (!memcg->use_hierarchy)
>> +			goto out;
>> +
>> +		for_each_mem_cgroup_tree(iter, memcg) {
>> +			if (iter == memcg)
>> +				continue;
>> +			memcg_kmem_account_parent(iter);
>> +		}
> 
> Could you add an explanation comment ?
> 

Of course, Kame.
Thanks

