Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab2JaUOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:14:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760737Ab2JaUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:14:22 -0400
Date: Wed, 31 Oct 2012 21:14:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031201415.GG1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-2-git-send-email-tj@kernel.org>
 <20121031200859.GE1271@dhcp22.suse.cz>
 <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 13:11:02, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 31, 2012 at 1:08 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > local_irq_disable doesn't guarantee atomicity, because other CPUs will
> 
> Maybe it should say atomicity on the local CPU.

That would be more clear but being more verbose doesn't hurt either :P

> > see the change in steps so this is a bit misleading. The real reason
> > AFAICS is that we do not want to hang in css_tryget from IRQ context
> > (does this really happen btw.?) which would interrupt cgroup_rmdir
> > between we add CSS_DEACT_BIAS and the group is marked CGRP_REMOVED.
> > Or am I still missing the point?
> 
> Yeah, that's the correct one. We don't want tryget happening between
> DEACT_BIAS and REMOVED as it can hang forever there.

-- 
Michal Hocko
SUSE Labs
