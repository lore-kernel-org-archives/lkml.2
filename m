Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1DGDHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:07:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:60419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab1DGDHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,314,1299484800"; 
   d="scan'208";a="624767317"
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: "Alex,Shi" <alex.shi@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "riel@redhat.com" <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <1302077064.2225.1357.camel@twins>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <1302077064.2225.1357.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 11:08:53 +0800
Message-ID: <1302145733.15889.7472.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 16:04 +0800, Peter Zijlstra wrote:
> On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:
> > commit ac53db596cc08ecb8040c removed the sched_yield task running
> > time increase, so the yielded task get more opportunity to be launch
> > again. That may not the caller want to be. And this also causes
> > volano benchmark drop 50~80 percent performance on core2/NHM/WSM
> > machines. This patch recover the sched_yield task vruntime up.
> 
> You do know that any app that relies on sched_yield behaviour is more
> than broken? Using sched_yield() for anything other than SCHED_FIFO
> tasks is well outside spec.
> 
> Furthermore, apparently you used sysctl_sched_compat_yield, which was
> bound to disappear some time, since with the default settings the yield
> semantics didn't actually change.

Yes, I used sched_compat_yield, otherwise volano will become extremely
slow in my single machine testing. We may reconsider our testing
setting. 

On the other side, after scheduler change to CFS, the task priority was
converted into load.weight and calculated into vruntime, the originally
meaningful of sched_yield system call is very hard to implement.
Considering this, I understand your decision on this. 
> 
> So no, I'm not much inclined to accept this. The Java people have had
> every opportunity to go fix their crap, them not doing so will
> eventually (preferably now) stop being my problem.
> 


