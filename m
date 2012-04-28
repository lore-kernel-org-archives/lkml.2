Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2D1Vb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:31:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2D1Vb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:31:56 -0400
Date: Sat, 28 Apr 2012 14:31:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Message-ID: <20120428213151.GA4586@mtj.dyndns.org>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
 <20120427204035.GN26595@google.com>
 <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
 <20120428020003.GA26573@mtj.dyndns.org>
 <CABEgKgpPXPu3L6oS6+2+dZmcPS=t-ZR7PnCvm0mo8UFeXPHDog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABEgKgpPXPu3L6oS6+2+dZmcPS=t-ZR7PnCvm0mo8UFeXPHDog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAME.

On Sat, Apr 28, 2012 at 06:31:38PM +0900, Hiroyuki Kamezawa wrote:
> > So, IMHO, just making pre_destroy() clean up its own charges and
> > always returning 0 is enough.  There's no need to fix up old
> > non-critical race condition at this point in the patch stream.  cgroup
> > rmdir simplification will make them disappear anyway.
>
> So, hmm, ok. I'll drop patch 7 & 8. memcg may return -EBUSY in very very
> race case but users will not see it in the most case.
> I'll fix limit, move-charge and use_hierarchy problem first.

IIUC, memcg can just return 0 when child creation races against
pre_destroy().  cgroup will retry if child exists after pre_destroy()
completion.  If child comes and goes before cgroup checks its
existence, some charges may be lost but that race already exists and
it will be gone once the retry logic is removed.  Also, returning
-errno will trigger WARN_ON() w/o the legacy behavior flag.

Thank you very much.

-- 
tejun
