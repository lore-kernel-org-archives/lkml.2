Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2ASWbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2ASWbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:31:03 -0500
Date: Thu, 19 Jan 2012 17:30:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] blkcg: kill blkio_policy_node
Message-ID: <20120119223056.GC4421@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-12-git-send-email-tj@kernel.org>
 <20120119203225.GA4421@redhat.com>
 <20120119220306.GK5198@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119220306.GK5198@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:03:06PM -0800, Tejun Heo wrote:

[..]
> > Why do we check for blkg->conf.weight=0 here. Even if a group already has
> > weight and if user has changed the cgroup weight later, that update should
> > be propogated to all the groups on all the queues.
> 
> Maybe I misread the code but if explicit per-device config exists,
> cgroup-wide writes are ignored, no?  The original code searches for
> matching pn and if it exists, continues without updating.
> 
> > Where do we assign default cgroup weight to a blkg upon creation? May be at
> > group create time, we just need to copy blkcg->weight to blkg.conf.weight.
> 
> We don't.  blk->conf.weight is set only on explicit per-device
> configuration.  It's gonna be removed eventually after config
> definition and handling are moved into policies.

Ok. So blkg->conf.weight is set only for per device weights. For groups
using cgroup weight, I see that cfq inherits it during group creation.
Any updates to cgroup weight are sent only if per device weight is not
set. Previously we used to do this check by looking for policy node and
you are checking for blkg.weight. That clarifies it. Thank.

Thanks
Vivek
