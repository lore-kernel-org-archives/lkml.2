Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0LCPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:09:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45492 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752362Ab0LCPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:09:57 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qx/BHtYNq+20tZsyoRx0c0dgl+DUUnPoKcTHdUB
	7R7vLVzeVbkpQJ
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: vatsa@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <4CF90341.4020101@redhat.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291355656.7633.124.camel@marge.simson.net>
	 <20101203134618.GG27994@linux.vnet.ibm.com>
	 <1291387511.7992.15.camel@marge.simson.net>  <4CF90341.4020101@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 16:09:47 +0100
Message-Id: <1291388987.7992.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 09:48 -0500, Rik van Riel wrote:
> On 12/03/2010 09:45 AM, Mike Galbraith wrote:
> 
> > I'll have to go back and re-read that.  Off the top of my head, I see no
> > way it could matter which container the numbers live in as long as they
> > keep advancing, and stay in the same runqueue.  (hm, task weights would
> > have to be the same too or scaled. dangerous business, tinkering with
> > vruntimes)
> 
> They're not necessarily in the same runqueue, the
> VCPU that is given time might be on another CPU
> than the one that was spinning on a lock.

I don't think pumping vruntime cross cfs_rq would be safe, for the
reason noted (et al).  No competition means vruntime is meaningless.
Donating just advances a clock that nobody's looking at.

	-Mike

