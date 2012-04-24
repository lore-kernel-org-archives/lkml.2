Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2DXRJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:09:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2DXRJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:09:29 -0400
Message-ID: <1335287354.28150.209.camel@twins>
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 19:09:14 +0200
In-Reply-To: <1335286696.28150.206.camel@twins>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
	 <1335286696.28150.206.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 18:58 +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 22:26 +0530, Srivatsa Vaddagiri wrote:
> > Steer a waking task towards a cpu where its cgroup has zero tasks (in
> > order to provide it better sleeper credits and hence reduce its wakeup
> > latency). 
> 
> That's just vile.. pjt could you post your global vruntime stuff so
> vatsa can have a go at that?

That is, you're playing a deficiency we should fix, not exploit.

Also, you do a second loop over all those cpus right after we've already
iterated them..

furthermore, that 100%+ gain is still way insane, what else is broken?
Did you try those paravirt tlb-flush patches and other such weirdness?
