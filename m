Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab2JaULH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:11:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55754 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab2JaULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:11:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121031200859.GE1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
	<1351712650-23709-2-git-send-email-tj@kernel.org>
	<20121031200859.GE1271@dhcp22.suse.cz>
Date: Wed, 31 Oct 2012 13:11:02 -0700
X-Google-Sender-Auth: ZFnlgekzA_kOYvZPELTtben9JtQ
Message-ID: <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 31, 2012 at 1:08 PM, Michal Hocko <mhocko@suse.cz> wrote:
> local_irq_disable doesn't guarantee atomicity, because other CPUs will

Maybe it should say atomicity on the local CPU.

> see the change in steps so this is a bit misleading. The real reason
> AFAICS is that we do not want to hang in css_tryget from IRQ context
> (does this really happen btw.?) which would interrupt cgroup_rmdir
> between we add CSS_DEACT_BIAS and the group is marked CGRP_REMOVED.
> Or am I still missing the point?

Yeah, that's the correct one. We don't want tryget happening between
DEACT_BIAS and REMOVED as it can hang forever there.

Thanks.

-- 
tejun
