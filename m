Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1J0Pcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:32:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab1J0Pco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:32:44 -0400
Date: Thu, 27 Oct 2011 11:32:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block:for-3.2/core] rescue cfq from RCU death sprial :)
Message-ID: <20111027153239.GF7491@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <20111026213629.GJ24261@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026213629.GJ24261@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 02:36:29PM -0700, Tejun Heo wrote:
> Hello, again.
> 
> On Tue, Oct 25, 2011 at 06:48:26PM -0700, Tejun Heo wrote:
> > This patchset contains the following 13 patches.
> > 
> >  0001-ida-make-ida_simple_get-put-IRQ-safe.patch
> >  0002-block-cfq-move-cfqd-cic_index-to-q-id.patch
> >  0003-block-misc-ioc-cleanups.patch
> >  0004-block-make-ioc-get-put-interface-more-conventional-a.patch
> >  0005-block-misc-updates-to-blk_get_queue.patch
> >  0006-block-cfq-misc-updates-to-cfq_io_context.patch
> >  0007-block-cfq-move-ioc-ioprio-cgroup-changed-handling-to.patch
> >  0008-block-cfq-fix-race-condition-in-cic-creation-path-an.patch
> >  0009-block-cfq-fix-cic-lookup-locking.patch
> >  0010-block-cfq-unlink-cfq_io_context-s-immediately.patch
> >  0011-block-cfq-remove-delayed-unlink.patch
> >  0012-block-cfq-kill-ioc_gone.patch
> >  0013-block-cfq-kill-cic-key.patch
> 
> 0001 removed (realized it's not necessary anymore) and sent out
> separately.  0004 and 0010 updated to address issues Vivek pointed
> out.  Both don't affect other patches.
> 
> git branch is updated to reflect the changes including dropping of ide
> related changes from the previous patchset.  You won't be able to pull
> this directly as I couldn't use commits for the previous patchset from
> the block tree (they're not there yet).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cfq-sync
> 
> When you want the whole series reposted, let me know.

These changes look good to me. It simplifies the locking (yes despite
double lock dance :-)) and gets rid of some race conditions.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
