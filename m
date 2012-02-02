Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2BBUd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:33:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36719 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2BBUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:33:57 -0500
Date: Thu, 2 Feb 2012 12:33:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] blkcg: let blkio_group point to blkio_cgroup
 directly
Message-ID: <20120202203352.GG19837@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-2-git-send-email-tj@kernel.org>
 <20120202200318.GB1723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202200318.GB1723@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 02, 2012 at 03:03:18PM -0500, Vivek Goyal wrote:
> > +static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
> > +{
> > +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> > +
> >  	if (blkcg != &blkio_root_cgroup)
> >  		kfree(blkcg);
> 
> What makes sure that all the blkg are gone and they have dropped their
> reference to blkcg? IIUC, pre-destroy will just make sure to decouple
> blkg from request queue as well as blkcg list and also drop joint cgroup
> and request queue reference.
> 
> But there could well be some IO queued in the group which might have
> its own reference and will be dropped later when IO completes. So at
> the time of blkiocg_destroy() it is not guranteed that there are
> no reference holders to blkcg?

Yeah, and that would wait till all css refs held by blkgs are gone,
right?

-- 
tejun
