Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2KTFbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:31:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43220 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:31:17 -0500
Date: Mon, 19 Nov 2012 21:31:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
Message-ID: <20121120053112.GE25790@mtj.dyndns.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
 <1353093624-22608-2-git-send-email-tj@kernel.org>
 <50AB086E.70901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB086E.70901@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kamezawa.

On Tue, Nov 20, 2012 at 01:34:54PM +0900, Kamezawa Hiroyuki wrote:
> I'm sorry if I misunderstand ... current usage of css-id in memory/swap cgroup
> is for recording information of memory cgroup which may be destroyed. In some case,
> a memcg's cgroup is freed but a struct memcgroup and its css are available, swap_cgroup
> may contain id ot if.
> This patch puts cgroup's id at diput(), so, the id used in swap_cgroup can be
> reused while it's in use. Right ?

CSSes hold onto cgroups, so if memcg is around, its cgroup doesn't go
away, so the right thing to do would be holding onto CSS whlie there
are remaining references, which IMHO is the way it should have been
implemented from the beginning.  The only reason memcg currently has
its own refcnt nested inside css refcnt is because cgroup used to
require css refs to be completely drained for cgroup_rmdir() to
proceed.  Now that that weirdity is gone, we should go back to sane
css based reference counting, right?

Thanks.

-- 
tejun
