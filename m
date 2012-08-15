Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2HONEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:04:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45076 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab2HONEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:04:40 -0400
Message-ID: <502B9E5F.2080907@parallels.com>
Date: Wed, 15 Aug 2012 17:04:31 +0400
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
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz> <502B9BD4.4070003@parallels.com> <20120815130228.GH23985@dhcp22.suse.cz>
In-Reply-To: <20120815130228.GH23985@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 05:02 PM, Michal Hocko wrote:
> On Wed 15-08-12 16:53:40, Glauber Costa wrote:
> [...]
>>>>> This doesn't check for the hierachy so kmem_accounted might not be in 
>>>>> sync with it's parents. mem_cgroup_create (below) needs to copy
>>>>> kmem_accounted down from the parent and the above needs to check if this
>>>>> is a similar dance like mem_cgroup_oom_control_write.
>>>>>
>>>>
>>>> I don't see why we have to.
>>>>
>>>> I believe in a A/B/C hierarchy, C should be perfectly able to set a
>>>> different limit than its parents. Note that this is not a boolean.
>>>
>>> Ohh, I wasn't clear enough. I am not against setting the _limit_ I just
>>> meant that the kmem_accounted should be consistent within the hierarchy.
>>>
>>
>> If a parent of yours is accounted, you get accounted as well. This is
>> not the state in this patch, but gets added later. Isn't this enough ?
> 
> But if the parent is not accounted, you can set the children to be
> accounted, right? Or maybe this is changed later in the series? I didn't
> get to the end yet.
> 

Yes, you can. Do you see any problem with that?


