Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1L2QXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:23:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60203 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab1L2QXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:23:19 -0500
Date: Thu, 29 Dec 2011 08:23:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Message-ID: <20111229162313.GD3516@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
 <20111228163631.GN17712@google.com>
 <4EFBD55E.5030106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFBD55E.5030106@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 29, 2011 at 10:50:06AM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> > Hello, Li.
> > 
> > On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
> >> The "name" option was introduced along with the "none" option, so we
> >> can distinguish between different cgroup hierarchies which have no
> >> bound subsystems, like this:
> >>
> >> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> >> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> >>
> >> As the name is unique, we have this "mount by hierarchy name" feature.
> > 
> > I could be missing something but does that add anything other than
> > naming convenience?
> 
> The name option is necessary, otherwise how can we mount hierarchies
> as shown in the above example?

I don't think mounting itself would be a problem.  We don't need name
option to create multiple tmpfs instances, right?  The problem is
referencing to them after they're created.  Filesystems generally
don't need such identifier because, once they're created, they can be
referenced by their mount points.  I'm still not very familiar with
different corners of cgroup, so it's entirely possible that I'm
missing something.  If I am, please point me to it.

> > If it's a redundant feature which has been broken over a year without
> > anyone complaining, it really doesn't need to exist.  It might not
> > save a lot of code but would save some WTH moments.
> > 
> 
> The redundant feature is mouting existing hierarchies by specifying name
> only, and the cleanup patch I sent has this feature removed in effect.
> 
> kernel/cgroup.c |   15 +++++++--------
> 1 files changed, 7 insertions(+), 8 deletions(-)
> 
> This is why I'm not so keen to remove the feature.

Code reduction is definitely a plus and I don't want to remove a
useful feature either, but an unusual redundant feature without
necessity is confusing / misleading even if it doesn't necessasrily
add a lot of code complexity.

Also, I at least want to understand why it's actually necessary before
applying the patches.  :)

Thanks.

-- 
tejun
