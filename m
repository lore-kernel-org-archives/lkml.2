Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2E2Q5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:57:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:59032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab2E2Q5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:57:22 -0400
Message-ID: <1338310613.26856.139.camel@twins>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 18:56:53 +0200
In-Reply-To: <4FC4FD51.2080001@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
	 <1338297385.26856.74.camel@twins> <20120529163849.GF21339@redhat.com>
	 <4FC4FD51.2080001@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 12:46 -0400, Rik van Riel wrote:
> > I don't think it's too great, memcg uses for half of that and yet
> > nobody is booting with cgroup_disable=memory even on not-NUMA servers
> > with less RAM.

Right, it was such a hit we had to disable that by default on RHEL6.

> Not any more. 

Right, hnaz did great work there, but wasn't there still some few pieces
of the shadow page frame left? ISTR LSF/MM talk of moving the last few
bits into the regular page frame, taking the word that became available
through: fc9bb8c768 ("mm: Rearrange struct page").


