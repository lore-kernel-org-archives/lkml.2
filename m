Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DATtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2DATtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:49:05 -0400
Date: Sun, 1 Apr 2012 15:48:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal
 optional
Message-ID: <20120401194823.GB6116@redhat.com>
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330223606.GK28934@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 03:36:06PM -0700, Tejun Heo wrote:
> Currently, cgroup removal tries to drain all css references.  If there
> are active css references, the removal logic waits and retries
> ->pre_detroy() until either all refs drop to zero or removal is
> cancelled.
> 
> This semantics is unusual and adds non-trivial complexity to cgroup
> core and IMHO is fundamentally misguided in that it couples internal
> implementation details (references to internal data structure) with
> externally visible operation (rmdir).  To userland, this is a behavior
> peculiarity which is unnecessary and difficult to expect (css refs is
> otherwise invisible from userland), and, to policy implementations,
> this is an unnecessary restriction (e.g. blkcg wants to hold css refs
> for caching purposes but can't as that becomes visible as rmdir hang).

Good to see this patch. Now annyoying rmdir hang with blkcg should be
gone.

Thanks
Vivek
