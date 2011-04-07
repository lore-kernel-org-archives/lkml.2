Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1DGGl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 02:41:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:14989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1DGGl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 02:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,315,1299484800"; 
   d="scan'208";a="415228379"
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: "Alex,Shi" <alex.shi@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <4D9D55EF.3090606@redhat.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <1302077064.2225.1357.camel@twins> <1302145733.15889.7472.camel@debian>
	 <4D9D55EF.3090606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 14:43:16 +0800
Message-ID: <1302158596.15889.7499.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 14:13 +0800, Rik van Riel wrote:
> On 04/06/2011 11:08 PM, Alex,Shi wrote:
> > On Wed, 2011-04-06 at 16:04 +0800, Peter Zijlstra wrote:
> >> On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:
> 
> >> You do know that any app that relies on sched_yield behaviour is more
> >> than broken? Using sched_yield() for anything other than SCHED_FIFO
> >> tasks is well outside spec.
> >>
> >> Furthermore, apparently you used sysctl_sched_compat_yield, which was
> >> bound to disappear some time, since with the default settings the yield
> >> semantics didn't actually change.
> >
> > Yes, I used sched_compat_yield, otherwise volano will become extremely
> > slow in my single machine testing. We may reconsider our testing
> > setting.
> 
> With what JVM is this happening?

I used openjdk from fedora 10~13 and jrockit-R27.3.1-jre1.5.0_11, both
of them use sched_yield much. And I just did a quick try with
jrockit-R27.4.0-jre1.6.0_02.x86_64, it had same problem.

> 
> Surely not every JVM uses user space spinlocks and
> yield, when we have futexes available?

No, just 7 times futex called in testing, so I think the JVM did not use
it. 
> 
> 
> 


