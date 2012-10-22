Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab2JVVSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:18:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35747 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2JVVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:18:28 -0400
Date: Mon, 22 Oct 2012 17:18:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN for
 PF_NOFREEZE or PF_FREEZER_SKIP tasks
Message-ID: <20121022211822.GF5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-5-git-send-email-tj@kernel.org>
 <20121022183453.GA24687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022183453.GA24687@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Oct 22, 2012 at 08:34:53PM +0200, Oleg Nesterov wrote:
> On 10/16, Tejun Heo wrote:
> >
> > cgroup_freezer doesn't transition from FREEZING to FROZEN if the
> > cgroup contains PF_NOFREEZE tasks or tasks sleeping with
> > PF_FREEZER_SKIP set.
> 
> And thus the patch looks like another bugfix to me.

It is but I'm not gonna send this one -stable.  Nobody has complained
yet and this is a userland visible behavior change, so I'd rather not
risk it.

> Just one question, and this question is offtopic again,
> 
> > Only kernel tasks can be non-freezable (PF_NOFREEZE)
> 
> Hmm. We seem to "leak" PF_NOFREEZE if a kernel thread execs?
> Perhaps do_execve_common() should do set_freezable() before return.
> 
> Or, at least, simply clear this flag along with PF_KTHREAD in
> flush_old_exec().

Ooh, ouch, definitely.  We should clear that.  Can you please make a
patch?

Thanks.

--
tejun
