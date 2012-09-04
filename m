Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2IDIiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:38:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51508 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab2IDIiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:38:03 -0400
Message-ID: <5045BD25.10301@parallels.com>
Date: Tue, 4 Sep 2012 12:34:45 +0400
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
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903170806.GA21682@dhcp22.suse.cz>
In-Reply-To: <20120903170806.GA21682@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 09:08 PM, Michal Hocko wrote:
> On Mon 03-09-12 19:46:51, Glauber Costa wrote:
>> Here is a new attempt to lay down a path that will allow us to deprecate
>> the non-hierarchical mode of operation from memcg.  Unlike what I posted
>> before, I am making this behavior conditional on a Kconfig option.
>> Vanilla users will see no change in behavior unless they don't
>> explicitly set this option to on.
> 
> Which is the reason why I don't like this approach. Why would you enable
> the option in the first place? If you know the default should be 1 then
> you would already do that via cgconfig or directly, right?
> I think we should either change the default (which I am planning to do
> for the next OpenSUSE) or do it slow way suggested by Tejun.
> We really want to have as big testing coverage as possible for the
> default change and config option is IMHO not a way to accomplish this.
> 

Not sure you realize, Michal, but you actually agree with me and my
patch, given your reasoning.

If you plan to change it in OpenSUSE, you have two ways of doing so:
You either carry a patch, which as simple as this is, is always
undesirable, or you add one line to your distro config. Pick my patch,
and do the later.

This patch does exactly the "do it slowly" thing, but without
introducing more churn, like mount options. Keep in mind that since
there is the concern that direct upstream users won't see a sudden
change in behavior, *every* way we choose to do it will raise the same
question you posed: "Why would you enable this in the first place?" Be
it a Kconfig, mount option, etc. The solution here is: Direct users of
upstream kernels won't see a behavior change - as requested - but
distributors will have a way to flip it without carrying a non-upstream
patch.


>> Distributions, however, are encouraged to set it.  
> 
> As I said, I plan to change the default with WARN_ONCE for both first
> cgroup created and default changed. It would be nice if other
> distributions could do the same but this might be tricky as nobody wants
> to regress and there are certain usecases which could really suffer
> (most of them fixable easily but there still might be some where
> use_hierarchy=0 is valid).
> 

tip: They can do the same without applying a non-upstream patch by using
this patch and just changing their default config.

