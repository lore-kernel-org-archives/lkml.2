Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2IQQkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:40:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65039 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2IQQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:40:07 -0400
Date: Mon, 17 Sep 2012 09:40:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120917164002.GA18677@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914142539.GC6221@redhat.com>
 <20120914213938.GV17747@google.com>
 <20120917150518.GB5094@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917150518.GB5094@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 17, 2012 at 11:05:18AM -0400, Vivek Goyal wrote:
> As a developer, I will be happy to support only one model and keep code
> simple. I am only concerned that for blkcg we have still not charted
> out a clear migration path. The warning message your patch is giving
> out will work only if we decide to not treat task and groups at same
> level.

It may not be enough but it still is in the right direction.

> > Another problem is that configuration isn't contained in cgroup
> > proper.  We need a way to assign weights to individual tasks which can
> > be somehow directly compared against group weights.  cpu cooks
> > priority for this and blkcg may be able to cook ioprio but it's nasty
> > and unobvious.  Also, let's say we grow network bandwidth controller
> > for whatever reason.  What value are we gonna use?
> 
> So if somebody cares about settting SO_PRIORITY for traffic originating
> from a tasks, move it into a cgroup. Otherwise they all get default
> priority.

I don't know.  Do we wanna add, say, prctl for memory weight too?

> So to me, leaving this decision to userspace based on their requirement
> makes sense.

Leaving too many decisions to userland is one of the reasons that got
us into this mess, so I'm not sold on flexibility for flexibility's
sake.

> Yes, creating a hidden group for tasks in current group should not be
> hard from implementation point of view. But again, I am concerned about
> configuration of hidden group and I also don't like the idea of taking
> flexibility away from user to treat tasks and group at same level.

I don't know.  Create a reserved directory for it?  I do like the idea
of taking flexibility away form user unless it's actually useful but
am a bit worried we might be too late for that. :(

Thanks.

-- 
tejun
