Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2JRTre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:47:34 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57692 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2JRTrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:47:32 -0400
Date: Thu, 18 Oct 2012 12:47:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v5 04/14] kmem accounting basic infrastructure
Message-ID: <20121018194727.GB13370@google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-5-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1210171455010.20712@chino.kir.corp.google.com>
 <508035E3.4080508@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508035E3.4080508@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Glauber.

On Thu, Oct 18, 2012 at 09:01:23PM +0400, Glauber Costa wrote:
> That is the offensive part. But it is also how things are done in memcg
> right now, and there is nothing fundamentally different in this one.
> Whatever lands in the remaining offenders, can land in here.

I think the problem here is that we don't have "you're committing to
creation of a new cgroup" callback and thus subsystem can't
synchronize locally against cgroup creation.  For task migration
->attach() does that but cgroup creation may fail after ->create()
succeeded so that doesn't work.

We'll probably need to add ->post_create() which is invoked after
creation is complete.  Li?

Thanks.

-- 
tejun
