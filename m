Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0KVLDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:03:08 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:57425 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0KVLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:03:05 -0500
Subject: Re: [patch 0/4] taskstats: Improve cumulative time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <1290197955.2109.1617.camel@laptop>
References: <20101119201108.269346583@linux.vnet.ibm.com>
	 <1290197955.2109.1617.camel@laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 22 Nov 2010 12:03:00 +0100
Message-ID: <1290423780.1974.1.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 21:19 +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 21:11 +0100, Michael Holzheu wrote:
> > Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
> > to the cumulative time of the parents, if the parents ignore SIGCHLD
> > or have set SA_NOCLDWAIT. This behaviour has the major drawback that
> > it is not possible to calculate all consumed CPU time of a system by
> > looking at the current tasks. CPU time can be lost.
> > 
> > To solve this problem, this patch set duplicates the cumulative accounting
> > data in the signal_struct. In the second set (cdata_acct) the complete
> > cumulative resource counters are stored. The new cumulative CPU time (utime
> > and stime) is then exported via the taskstats interface. 
> 
> Maybe this has been treated earlier in the threads and I missed it, but
> the obvious solution doesn't get mentioned:
> 
> What would break if we violate this silly POSIX rule and account time of
> childs regardless of SIGCHLD/SA_NOCLDWAIT?

Or maybe we could add a sysctl that allows to switch between the two
semantics.

Michael

