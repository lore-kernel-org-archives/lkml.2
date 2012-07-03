Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2GCUbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab2GCUbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:31:20 -0400
Date: Tue, 3 Jul 2012 22:30:32 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 05/40] autonuma: define _PAGE_NUMA_PTE and _PAGE_NUMA_PMD
Message-ID: <20120703203032.GV3726@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-6-git-send-email-aarcange@redhat.com>
 <4FEDBB1F.9030001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEDBB1F.9030001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Fri, Jun 29, 2012 at 10:26:39AM -0400, Rik van Riel wrote:
> On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> 
> > +/*
> > + * Cannot be set on pte. The fact it's in between _PAGE_FILE and
> > + * _PAGE_PROTNONE avoids having to alter the swp entries.
> > + */
> > +#define _PAGE_NUMA_PTE	_PAGE_PSE
> > +/*
> > + * Cannot be set on pmd, if transparent hugepages will be swapped out
> > + * the swap entry offset must start above it.
> > + */
> > +#define _PAGE_NUMA_PMD	_PAGE_UNUSED2
> 
> Those comments only tell us what the flags can NOT be
> used for, not what they are actually used for.

You can find an updated version of the comments here:

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=927ca960d78fefe6fa6aaa260a5b35496abafec5

Thanks for all the feedback, I didn't reply immediately but I'm
handling all the feedback and many more bits have been improved
already in the autonuma branch. I will post them separately for
further review.
