Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457Ab2ILQlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:41:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460Ab2ILQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:41:07 -0400
Date: Wed, 12 Sep 2012 09:41:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120912164102.GM7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <20120911170746.GL7677@google.com>
 <20120912154745.GV21579@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912154745.GV21579@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 12, 2012 at 05:47:45PM +0200, Michal Hocko wrote:
> > If it's absolutely necessary, I think it should be a root-only flag
> > (even if that ends up using the same code path).  Eventually, we
> > really want to kill .use_hierarchy, or at least make it to RO 1.  As
> > it's currently defined, it's just way too confusing.
> 
> Agreed on that, definitely.

The thing is that if we're gonna be headed that way, we're gonna have
to nudge people to .use_hierarchy = 1 everywher first.  If
.use_hierarchy = 0 at root is a valid use case which absolutedly needs
to be maintained (from what I read, I don't think it is), let's move
it to a different root-only flag; otherwise, it should be phased out.
As such, while the user might not be necessarily wrong, we still need
to unify the behavior, I think.

Thanks.

-- 
tejun
