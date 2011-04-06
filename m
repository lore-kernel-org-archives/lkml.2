Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1DFGNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:13:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:10711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1DFGNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:13:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,309,1299484800"; 
   d="scan'208";a="414569099"
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: "Alex,Shi" <alex.shi@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <4D9BF512.6080309@redhat.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <4D9BF512.6080309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 14:15:09 +0800
Message-ID: <1302070509.15889.7351.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 13:07 +0800, Rik van Riel wrote:
> On 04/05/2011 06:33 PM, Alex Shi wrote:
> > commit ac53db596cc08ecb8040c removed the sched_yield task running
> > time increase, so the yielded task get more opportunity to be launch
> > again. That may not the caller want to be. And this also causes
> > volano benchmark drop 50~80 percent performance on core2/NHM/WSM
> > machines. This patch recover the sched_yield task vruntime up.
> >
> > Signed-off-by: alex.shi@intel.com
> 
> NACK
> 
> This was switched off by default and under
> the sysctl sched_compat_yield for a reason.
> 
> Reintroducing it under that sysctl option
> may be acceptable, but by default it would
> be doing the wrong thing for other workloads.

I can implement this as sysctl option. But when I checked again the man
page of sched_yield. I have some concerns on this. 

----
       int sched_yield(void);

DESCRIPTION
       A  process  can  relinquish  the processor voluntarily without blocking by calling sched_yield().
       The process will then be moved to the end of the queue for its static priority and a new  process
       gets to run.
----

If a application calls sched_yield system call, most of time it is not
want to be launched again right now. so the man page said "the caller
process will then be moved to the _end_ of the queue..."

