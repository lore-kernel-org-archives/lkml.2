Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2IEIRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:17:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49123 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2IEIRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:17:43 -0400
Message-ID: <504709D4.2010800@parallels.com>
Date: Wed, 5 Sep 2012 12:14:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903170806.GA21682@dhcp22.suse.cz> <5045BD25.10301@parallels.com> <20120904130905.GA15683@dhcp22.suse.cz> <504601B8.2050907@parallels.com> <20120904143552.GB15683@dhcp22.suse.cz> <50461241.5010300@parallels.com> <20120904145414.GC15683@dhcp22.suse.cz> <50461610.30305@parallels.com> <20120904162501.GE15683@dhcp22.suse.cz>
In-Reply-To: <20120904162501.GE15683@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 08:25 PM, Michal Hocko wrote:
> On Tue 04-09-12 18:54:08, Glauber Costa wrote:
> [...]
>>>> I'd personally believe merging both our patches together would achieve a
>>>> good result.
>>>
>>> I am still not sure we want to add a config option for something that is
>>> meant to go away. But let's see what others think.
>>>
>>
>> So what you propose in the end is that we add a userspace tweak for
>> something that could go away, instead of a Kconfig for something that go
>> away.
> 
> The tweak is necessary only if you want to have use_hierarchy=1 for all
> cgroups without taking care about that (aka setting the attribute for
> the first level under the root). All the users that use only one level
> bellow root don't have to do anything at all.
> 
>> Way I see it, Kconfig is better because it is totally transparent, under
>> the hood, and will give us a single location to unpatch in case/when it
>> really goes away.
> 
> I guess that by the single location you mean that no other user space
> changes would have to be done, right? If yes then this is not true
> because there will be a lot of configurations setting this up already
> (either by cgconfig or by other scripts). All of them will have to be
> fixed some day.
> 

Some userspaces, not all. And the ones who set:

They are either explicitly setting to 0, and those are the ones we need
to find out, or they are setting to 1, which will be harmless. If they
were all mandated to do it, fine. But they are not everywhere, and much
many other exists that don't touch it at all. What you are proposing is
that *all* userspace tools that use it go flip it, instead of doing it
in the kernel.

As I've said before, distributions have lifecycles where changes in
behavior like this are tolerated. Some of those lifecycles are
incredibly long, in the 5+ years range. It could be really nice if they
would never see use_hierarchy=0 *at all*, which is much better
accomplished by a kernel-side switch. A Kconfig option is the choice
between carrying either an upstream patch or no patch at all (Depending
on timing), and carrying a non-standard patch.



