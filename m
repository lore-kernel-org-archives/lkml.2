Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab2JWPy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab2JWPyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:54:25 -0400
Date: Tue, 23 Oct 2012 17:55:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN
	for PF_NOFREEZE or PF_FREEZER_SKIP tasks
Message-ID: <20121023155533.GC16201@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org> <20121022183453.GA24687@redhat.com> <20121022211822.GF5951@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022211822.GF5951@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Tejun Heo wrote:
>
> On Mon, Oct 22, 2012 at 08:34:53PM +0200, Oleg Nesterov wrote:
> >
> > Hmm. We seem to "leak" PF_NOFREEZE if a kernel thread execs?
> > Perhaps do_execve_common() should do set_freezable() before return.
> >
> > Or, at least, simply clear this flag along with PF_KTHREAD in
> > flush_old_exec().
>
> Ooh, ouch, definitely.  We should clear that.  Can you please make a
> patch?

Sure... but what do you think is better?

I'd prefer to simply clear PF_NOFREEZE (without set_freezable), but
obviously this doesn't look exactly right from cgroup_freezer pov.

Oleg.

