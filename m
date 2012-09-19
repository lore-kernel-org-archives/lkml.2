Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2ISHnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:43:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52502 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab2ISHnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:43:15 -0400
Message-ID: <505976B5.6090801@parallels.com>
Date: Wed, 19 Sep 2012 11:39:33 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3 05/13] Add a __GFP_KMEMCG flag
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-6-git-send-email-glommer@parallels.com> <00000139d9ea69c6-109249c2-5176-4a1e-b000-4c076d05844d-000000@email.amazonses.com>
In-Reply-To: <00000139d9ea69c6-109249c2-5176-4a1e-b000-4c076d05844d-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 07:06 PM, Christoph Lameter wrote:
> On Tue, 18 Sep 2012, Glauber Costa wrote:
> 
>> +++ b/include/linux/gfp.h
>> @@ -35,6 +35,11 @@ struct vm_area_struct;
>>  #else
>>  #define ___GFP_NOTRACK		0
>>  #endif
>> +#ifdef CONFIG_MEMCG_KMEM
>> +#define ___GFP_KMEMCG		0x400000u
>> +#else
>> +#define ___GFP_KMEMCG		0
>> +#endif
> 
> Could you leave __GFP_MEMCG a simple definition and then define GFP_MEMCG
> to be zer0 if !MEMCG_KMEM? I think that would be cleaner and the
> __GFP_KMEMCHECK another case that would be good to fix up.
> 
> 
> 
I can, but what does this buy us?
Also, in any case, this can be done incrementally, and for the other
flag as well, as you describe.



