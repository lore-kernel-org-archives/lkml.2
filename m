Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2ISOCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:02:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab2ISOCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:02:12 -0400
Date: Wed, 19 Sep 2012 16:02:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120919140203.GA5398@dhcp22.suse.cz>
References: <20120913205827.GO7677@google.com>
 <20120914150306.GQ28039@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914150306.GQ28039@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Dave, Ben]

Just a short summary as you were not on the CC list. This is sort of
follow up on https://lkml.org/lkml/2012/9/3/211. The end result is
slightly different because Tejun did a more generic cgroup solution (see
bellow). I cannot do the same for OpenSUSE so I will stick with the
memcg specific patch.

On Fri 14-09-12 17:03:06, Michal Hocko wrote:
> I am currently planning to add a warning to most of the currenly
> maintained distributions to have as big coverage as possible. No default
> switch for obvious reasons but hopefuly we will get some feedback at
> least.

Just for the record, I will post backports of the patch I ended up using
for openSUSE 11.4 and 12.[12] and SLES-SP2 as a reply to this email (and
2.6.32 in case somebody is interested).

I hope other distributions can either go with this (which will never be
merged but it should help to identify dubious usage of flat hierarchies
without a risk of breaking anythign) or what Tejun has in his tree[1]
8c7f6edb (cgroup: mark subsystems with broken hierarchy support and
whine if cgroups are nested for them) which is more generic but it is
also slightly more intrusive.

---
[1] - git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-hierarchy
-- 
Michal Hocko
SUSE Labs
