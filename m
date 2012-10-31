Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab2JaUtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:49:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760217Ab2JaUto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:49:44 -0400
Date: Wed, 31 Oct 2012 21:49:36 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031204936.GI1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-2-git-send-email-tj@kernel.org>
 <20121031200859.GE1271@dhcp22.suse.cz>
 <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
 <20121031201415.GG1271@dhcp22.suse.cz>
 <20121031202400.GT2945@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031202400.GT2945@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 13:24:00, Tejun Heo wrote:
[...]
> local_irq_save/restore() from cgroup_clear_css_refs() are replaced
> with local_irq_disable/enable() for simplicity.  This is safe as
> cgroup_rmdir() is always called with IRQ enabled.  Note that this IRQ
> switching is necessary to ensure that css_tryget() isn't called from
> IRQ context on the same CPU while lower context is between CSS
> deactivation and setting CSS_REMOVED as css_tryget() would hang
> forever in such cases waiting for CSS to be re-activated or
> CSS_REMOVED set.  This will go away soon.

Much better. Thanks a lot!
-- 
Michal Hocko
SUSE Labs
