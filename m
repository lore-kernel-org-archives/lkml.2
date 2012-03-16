Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2CPVNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:13:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:42944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2CPVNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:13:36 -0400
Message-ID: <1331932375.18960.237.camel@twins>
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 16 Mar 2012 22:12:55 +0100
In-Reply-To: <alpine.DEB.2.00.1203161333370.10211@router.home>
References: <20120316144028.036474157@chello.nl>
	 <20120316144240.763518310@chello.nl>
	 <alpine.DEB.2.00.1203161333370.10211@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 13:34 -0500, Christoph Lameter wrote:
> On Fri, 16 Mar 2012, Peter Zijlstra wrote:
> 
> > Add another layer of fallback policy to make the home node concept
> > useful from a memory allocation PoV.
> >
> > This changes the mpol order to:
> >
> >  - vma->vm_ops->get_policy	[if applicable]
> >  - vma->vm_policy		[if applicable]
> >  - task->mempolicy
> >  - tsk_home_node() preferred	[NEW]
> >  - default_policy
> >
> > Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
> > facilitate efficient on-demand memory migration.
> 
> The numa hierachy is already complex. Could we avoid adding another layer
> by adding a MPOL_HOME_NODE and make that the default?

Not sure that's really a win, the behaviour would be the same we just
have to implement another policy, which is likely more code.
