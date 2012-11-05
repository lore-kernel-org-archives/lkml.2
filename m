Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2KET0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:26:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59598 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2KET0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:26:41 -0500
Date: Mon, 5 Nov 2012 11:26:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Glauber Costa <glommer@parallels.com>, rjw@sisk.pl,
        linux-pm@vger.kernel.org, fweisbec@gmail.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mhocko@suse.cz, cgroups@vger.kernel.org
Subject: Re: [RFC] cgroup: deprecate clone_children
Message-ID: <20121105192636.GG19354@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <5097C23B.3040808@parallels.com>
 <20121105180213.GB19354@mtj.dyndns.org>
 <20121105191714.GA24560@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105191714.GA24560@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Serge.

On Mon, Nov 05, 2012 at 01:17:14PM -0600, Serge Hallyn wrote:
> > As this is unnecessary feature with very limited use and awkward in
> 
> clone_children is currently required by lxc.  Of course lxc could
> manually set the .cpus and .mems in the newly created child, but if
> those interfaces or others like it ever change (i.e. any new ones which
> must be set before a task can join a cgroup) we'll get into yet more of
> a rats nets of code to support different kernel versions.

If lxc is using it, this will have to stay then.  I'll try to make it
a cpuset specific thing.

> (Just as an idea, if there was a way to generically tell from the list
> of files in my cgroups dir which files need to be initialized before a
> task can join, I think that would suffice.  Maybe a cgroups.needssetup
> file which right now contains 'cpuset.mems\ncpuset.cpus'. Then if we
> find a file we don't recognize in there we can throw an intelligent
> error, or guess at duplicating the parent value.)

Hmmm... I think the root problem is that different controllers don't
agree on the way they inherit configurations from parents.  cgroup
really is a trainwreck.  :(

I don't know whether "needssetup" is the right way to deal with it.
I'll think more about it.

> > co-mounted use cases, let's try to deprecate it.  Whine on the mount
> > option and accesses to cgroupfs knobs.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Glauber Costa <glommer@parallels.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > ---
> > Glauber, I think this is more befitting change for .post_clone().  If
> 
> What do you mean by that?  That he is working on a patch-set which will
> remove post_clone and this belongs there, or that there is a proposed
> alternative?

The former.  There was a patchset from Glauber updating ->post_clone()
(which didn't change the behavior).

Thanks.

-- 
tejun
