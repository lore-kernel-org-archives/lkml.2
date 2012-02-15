Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2BORCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:02:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2BORCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:02:36 -0500
Date: Wed, 15 Feb 2012 12:02:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED2 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120215170229.GE27312@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120214013347.GK12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214013347.GK12117@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 05:33:47PM -0800, Tejun Heo wrote:

[..]
> Modified to update root blkgs on elvswitch too.
> 
> Jens, there are a couple other changes but they're all trivial.  I
> didn't want to repost both patchsets for those changes.  The git
> branch has been updated.  Ping me if you want the full series
> reposted.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-unified-blkg
> 
> I'd really like to get this into block/core and get some exposure in
> linux-next.  There still are a lot of transitional stuff but I feel
> that there's now somewhat solid ground to build stuff atop.  Vivek,
> what do you think?

Hi Tejun,

As this patch series is getting longer (already 2 sets are out there), I
think it is reasonable to get some testing going in linux-next. I can think
of atleast few more things which you might be planning to push before
3.4 merge window opens.

- Cleanup in-place policy data update logic.

- Do not kill all the groups upon one policy switch. Keep the group around
  and just kill the policy data of associated policy.

- Get rid if locking complexity and rcu around group removal. Replace with
  double lock dancing stuff.

- Fix the per cpu alloc stat alloc mess. This is anyway needed
  irrespective of cleanup.

Thanks
Vivek
