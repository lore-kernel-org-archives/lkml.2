Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab2KTFof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:44:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33807 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2KTFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:44:34 -0500
Date: Mon, 19 Nov 2012 21:44:28 -0800
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Message-ID: <20121120054428.GF25790@mtj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <20121119192142.GM15971@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119192142.GM15971@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Mon, Nov 19, 2012 at 11:21:42AM -0800, Tejun Heo wrote:
> On Fri, Nov 16, 2012 at 07:30:59PM -0800, Tejun Heo wrote:
> > Hello, guys.
> > 
> > This patchset implements proper hierarchy support for netcls_cgroup.
> > Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> > single config value instead of array of them.
> 
> Applied to cgroup/for-3.8.

I'm kinda having a second thought about this and reverted it for the
time being.  The problem is that there are other configurations which
are only inherited while creating a new child cgroup without
propagating new configuration afterwards -
e.g. cpuset.memory_spread_*, and given that cpuset has been around for
quite some time and has been one of the popular controllers, I don't
think we can change the behavior at this point.

It looks like we'll have to have some mixture of both behaviors.
Anything resource limit related should affect its descendants while
other per-cgroup attributes don't, with the distinction between the
two muddy at times.

So, if we're gonna have to do that anyway, I can't find a strong
rationale for changing net_cls's behavior of not propagating on
ancestor update, and net_prio should match net_cls's behavior -
ie. inherit on cgroup creation but then operate separately.

I'll prep a new patchset to update netprio accordingly.

Thanks.

-- 
tejun
