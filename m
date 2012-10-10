Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2JJOdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:33:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:19858 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2JJOdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,564,1344236400"; 
   d="scan'208";a="202812341"
Date: Wed, 10 Oct 2012 22:33:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-linus] memcg, kmem: fix build error when CONFIG_INET
 is disabled
Message-ID: <20121010143331.GA7880@localhost>
References: <alpine.DEB.2.00.1210092325500.9528@chino.kir.corp.google.com>
 <5075383A.1000001@parallels.com>
 <20121010092700.GD23011@dhcp22.suse.cz>
 <50753FFF.6060102@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50753FFF.6060102@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 01:29:35PM +0400, Glauber Costa wrote:
> On 10/10/2012 01:27 PM, Michal Hocko wrote:
> > On Wed 10-10-12 12:56:26, Glauber Costa wrote:
> >> On 10/10/2012 10:32 AM, David Rientjes wrote:
> >>> Commit e1aab161e013 ("socket: initial cgroup code.") causes a build error 
> >>> when CONFIG_INET is disabled in Linus' tree:
> >>>
> >> unlikely that something that old would cause a build bug now, specially
> >> that commit, that actually wraps things inside CONFIG_INET.
> >>
> >> More likely caused by the recently merged
> >> "memcg-cleanup-kmem-tcp-ifdefs.patch" in -mm by mhocko (CC'd)
> > 
> > Strange it didn't trigger during my (and Fenguang) build testing.
> 
> Fengguang mentioned to me while testing my kmemcg tree that were a build
> error occurring in the base tree, IOW, yours.

Yes, and the errors were sent to/cc Michal and kernel-janitors@vger.kernel.org

> Fengguang, was that this error? Why hasn't it showed up before in the
> test system?

I do find this error in the build error log:

        (.text+0x867f): undefined reference to `sock_update_memcg'
        2012-09-24 04:54:53 snb next:akpm:69921c3 x86_64-randconfig-s005 0a7f618

Unfortunately it was not reported because the build system could
miss/ignore build bugs due to various reasons/imperfections. It has
since then undergo lots of enhancements and as a result, the daily
reported errors have more than doubled. :-)

Thanks,
Fengguang
