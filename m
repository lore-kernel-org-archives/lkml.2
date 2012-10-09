Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2JIPPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:15:15 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58205 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab2JIPPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:15:13 -0400
Message-ID: <50743F71.7090409@parallels.com>
Date: Tue, 9 Oct 2012 19:14:57 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, <devel@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 08/14] res_counter: return amount of charges after
 res_counter_uncharge
References: <1349690780-15988-1-git-send-email-glommer@parallels.com> <1349690780-15988-9-git-send-email-glommer@parallels.com> <20121009150845.GC7655@dhcp22.suse.cz>
In-Reply-To: <20121009150845.GC7655@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 07:08 PM, Michal Hocko wrote:
> As I have already mentioned in my previous feedback this is cetainly not
> atomic as you the lock protects only one group in the hierarchy. How is
> the return value from this function supposed to be used?

So, I tried to make that clearer in the updated changelog.

Only the value of the base memcg (the one passed to the function) is
returned, and it is atomic, in the sense that it has the same semantics
as the atomic variables: If 2 threads uncharge 4k each from a 8 k
counter, a subsequent read can return 0 for both. The return value here
will guarantee that only one sees the drop to 0.

This is used in the patch "kmem_accounting lifecycle management" to be
sure that only one process will call mem_cgroup_put() in the memcg
structure.

