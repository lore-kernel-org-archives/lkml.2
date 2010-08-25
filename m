Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0HYBro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:47:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42037 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0HYBrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:47:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 10:42:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825104240.7dbaba6a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikuJ9x1u+GC_ox448Fp9wdJ2_GJyu6kNwjOJ9Y=@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
	<20100825093747.24085b28.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=KW_gxbmB14j5opSKL+-JFDFKO1YP6a7yvT8U5@mail.gmail.com>
	<20100825100310.ba3fd27e.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikuJ9x1u+GC_ox448Fp9wdJ2_GJyu6kNwjOJ9Y=@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 18:35:00 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Aug 24, 2010 at 6:03 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Hmm. How this pseudo code looks like ? This passes "new id" via
> > cgroup->subsys[array] at creation. (Using union will be better, maybe).
> >
> 
> That's rather ugly. I was thinking of something more like this. (Not
> even compiled yet, and the only subsystem updated is cpuset).
> 

Hmm, but placing css and subsystem's its own structure in different cache line
can increase cacheline/TLB miss, I think.

I wonder I should stop this patch series and do small thing.
I prefer to call alloc_css_id() by ->create() call by subsys's its own decistion
is much better and cleaner. (as my original design)

mem_cgroup_create()
{

	cgroup_attach_css_id(ss, cgrp, &mem->css);
}

And then, there will be no difficulty.

Do we have to call alloc_css_id() in kernel/cgroup.c ?

Thanks,
-Kame

