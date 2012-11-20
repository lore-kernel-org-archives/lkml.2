Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2KTOkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:40:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58766 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2KTOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:40:41 -0500
Date: Tue, 20 Nov 2012 06:40:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] netprio_cgroup: allow nesting and inherit config on
 cgroup creation
Message-ID: <20121120144036.GP15971@htj.dyndns.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
 <1353400211-5182-8-git-send-email-tj@kernel.org>
 <50AB45EA.2050507@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB45EA.2050507@monom.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Daniel.

On Tue, Nov 20, 2012 at 09:57:14AM +0100, Daniel Wagner wrote:
> >-static void cgrp_css_free(struct cgroup *cgrp)
> >+static int cgrp_css_online(struct cgroup *cgrp)
> >  {
> >-	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
> >+	struct cgroup *parent = cgrp->parent;
> >  	struct net_device *dev;
> >+	int ret = 0;
> >+
> >+	if (!parent)
> >+		return 0;
> 
> BTW, parent is always != NULL, because the root cgroup will be
> attached to the dummytop cgroup.

Hmmm?  I'm confused.  When ->css_online() is called for dummytop in
cgroup_init_subsys(), its parent is NULL.  What am I missing?

Thanks.

-- 
tejun
