Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab2BCVxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:53:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab2BCVxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:53:53 -0500
Date: Fri, 3 Feb 2012 16:53:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203215349.GF9683@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
 <20120203214435.GC12616@redhat.com>
 <20120203214719.GE14209@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203214719.GE14209@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:47:19PM -0800, Tejun Heo wrote:
> On Fri, Feb 03, 2012 at 04:44:35PM -0500, Vivek Goyal wrote:
> > Ok, looks like now it is needed because blkcg lock will just gurantee that
> > blkg is around but blkg->pd[plid] can disappear if you are not holding
> > blkio_list lock (update_root_blkgs).
> > 
> > I am wondering if we should take blkcg->lock if blkg is on blkcg list and
> > is being modified in place. That way, once we are switching elevator,
> > we should be able to shoot down the policy data without taking blkio_list
> > lock.
> 
> I think it gotta become something per-queue, not global, and if we
> make it per-queue, it should be able to live inside queue_lock.

Hmm... then blkiocg_reset_stats() will run into lock ordering issue. Can't
hold queue lock inside blkcg lock. I guess you will do some kind of
locking trick again as you did for io context logic.

Thanks
Vivek
