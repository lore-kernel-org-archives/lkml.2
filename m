Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2IDIdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:33:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38537 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab2IDIdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:33:05 -0400
Message-ID: <5045BBF6.5000900@parallels.com>
Date: Tue, 4 Sep 2012 12:29:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903164148.GS29217@decadent.org.uk>
In-Reply-To: <20120903164148.GS29217@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>> +	  of the root memcg, regardless of their positioning in the tree.
>> +
>> +	  Use of flat hierarchies is highly discouraged, but has been the
>> +	  default for performance reasons for quite some time. Setting this flag
>> +	  to on will make hierarchical accounting the default. It is still
>> +	  possible to set it back to flat by writing 0 to the file
>> +	  memory.use_hierarchy, albeit discouraged. Distributors are encouraged
>> +	  to set this option.
> [...]
> 
> I don't think that 'default n' is effective encouragement!
> 
> Ben.
> 
If it were up to me, I would just flip it to 1. No option.
A bit of history here, is that people have a - quite valid - concern
that this will disrupt users using their own kernel, should they decide
to update, recompile and run.

Conditional on a Kconfig option, people reusing their .config will see
no change. Distros, otoh, are versioned. It is not unreasonable to
expect a behavior change when a major version flips.

The encouragement here comes not from the default, but from the
acknowledgment that his thing is totally broken, and we need to act to
fix it in a compatible way.

