Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829Ab2ILRJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:09:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760618Ab2ILRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:09:37 -0400
Date: Wed, 12 Sep 2012 10:09:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120912170933.GO7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50505C39.1050600@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 12, 2012 at 01:56:09PM +0400, Glauber Costa wrote:
> "Being able to provide hierarchical support" is an example of such
> restrictions. And as Vivek said himself, for the CFQ case should be doable.

Yeah, it's mostly that cfq was already a hairy monster before blkcg
was added to it and unfortunately we didn't make it any cleaner in the
process and blkcg itself has a lot of other issues including being
completely broken w.r.t. writeback writes.  In addition there are two
sub-controllers - the cfq one and blk-throttle.  So, it's just that
there are too many scary things to do and not enough man power or
maybe interest.  I hope we could just declare cgroup isn't supported
on block devices but that doesn't seem feasible at this point either.

I might / probably work on it and am hoping to coerce Vivek into it
too.  If you wanna jump in, please be my guest.

Thanks.

-- 
tejun
