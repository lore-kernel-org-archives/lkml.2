Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2CLSMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:12:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55946 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2CLSMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:12:14 -0400
Date: Mon, 12 Mar 2012 11:12:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Call cgroup_path only under cgroup lock
Message-ID: <20120312181208.GD23255@google.com>
References: <1331582478-2259-1-git-send-email-levinsasha928@gmail.com>
 <20120312180423.GC23255@google.com>
 <CA+1xoqdz+m7kK+XgsmwM2Bt07eLH294L_PT6DrUkhJvRzpUZCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqdz+m7kK+XgsmwM2Bt07eLH294L_PT6DrUkhJvRzpUZCg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 08:06:53PM +0200, Sasha Levin wrote:
> On Mon, Mar 12, 2012 at 8:04 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Sasha.
> >
> > On Mon, Mar 12, 2012 at 04:01:18PM -0400, Sasha Levin wrote:
> >> Since we can't keep rcu read lock during blkg_alloc(), we currently
> >> call cgroup_path() without any locks at all.
> >>
> >> This patch adds cgroup locking before calling cgroup_path.
> >>
> >> This also fixes a lockdep warning on boot.
> >>
> >> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> >
> > Which branch is this against?  There's already pending stat update
> > patch from Vivek which fix this problem along with the percpu
> > allocation problem.
> >
> > Thanks.
> 
> I've fixed it for linux-next.

Jens, the pending stats patchset should fix this problem too.  Can you
please put them on top of other blkcg updates?

Thanks.

-- 
tejun
