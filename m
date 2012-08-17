Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab2HQKmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:42:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:32930 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab2HQKme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:42:34 -0400
Message-ID: <502E1F5B.9090601@parallels.com>
Date: Fri, 17 Aug 2012 14:39:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <20120817090005.GC18600@dhcp22.suse.cz> <502E0BC3.8090204@parallels.com> <20120817093504.GE18600@dhcp22.suse.cz> <502E17C4.7060204@parallels.com> <20120817103550.GF18600@dhcp22.suse.cz>
In-Reply-To: <20120817103550.GF18600@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 02:35 PM, Michal Hocko wrote:
> On Fri 17-08-12 14:07:00, Glauber Costa wrote:
>> On 08/17/2012 01:35 PM, Michal Hocko wrote:
>>>>> Above you said "Once enabled, can't be disabled." and now you can
>>>>>>> disable it? Say you are a leaf group with non accounted parents. This
>>>>>>> will clear the flag and so no further accounting is done. Shouldn't
>>>>>>> unlimited mean that we will never reach the limit? Or am I missing
>>>>>>> something?
>>>>>>>
>>>>>
>>>>> You are missing something, and maybe I should be more clear about that.
>>>>> The static branches can't be disabled (it is only safe to disable them
>>>>> from disarm_static_branches(), when all references are gone). Note that
>>>>> when unlimited, we flip bits, do a transversal, but there is no mention
>>>>> to the static branch.
>>> My little brain still doesn't get this. I wasn't concerned about static
>>> branches. I was worried about memcg_can_account_kmem which will return
>>> false now, doesn't it.
>>>
>>
>> Yes, it will. If I got you right, you are concerned because I said that
>> can't happen. But it will.
>>
>> But I never said that can't happen. I said (ok, I meant) the static
>> branches can't be disabled.
> 
> Ok, then I misunderstood that because the comment was there even before
> static branches were introduced and it made sense to me. This is
> inconsistent with what we do for user accounting because even if we set
> limit to unlimitted we still account. Why should we differ here?
> 
There is another thing as well. Mel was right in his comment: I am
actually abusing this bit (because it is flippable), and it seems the
static branch can be updated more than once...

I'll merge your comments, and fix this.
