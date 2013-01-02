Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3ABQws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:52:48 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36925 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3ABQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:52:45 -0500
Date: Wed, 2 Jan 2013 11:52:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Message-ID: <20130102165242.GD11220@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
 <20130102162415.GA4306@redhat.com>
 <20130102163010.GC11220@mtj.dyndns.org>
 <20130102164415.GB4306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102164415.GB4306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Wed, Jan 02, 2013 at 11:44:15AM -0500, Vivek Goyal wrote:
> > > In fact if we have a realiable way of resetting status then online/offline
> > > infrastructure might not be required? I think per cpu stats will be a
> > > problem though and that's why we probably require logic to online/offline
> > > the group?
> > 
> > Hmmm?  What do you mean?
> 
> I mean if we had a reliable way of resetting stats after transferring
> then we would not need to keep a track of whether group is online/offline.
> We could add everything and adding zero will not change anything. In fact
> it will also take care of residual IO (IO which happened after transfer
> of stats).

Ah... yeah, if we can do atomic transfer, we might be able to do away
with on/offlining.  Couldn't think of a way to do that without
incurring overhead to hot paths.

> Or I missed the real reason of why do we have group online/offline
> infrastructure.

But given that on/offline state is something common to cgroup, I don't
think adding the states to blkcg is a bad idea.  We need it for
reliable iterations anyways.

Thanks.

-- 
tejun
