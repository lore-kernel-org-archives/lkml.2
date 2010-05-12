Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0ELLMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:12:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0ELLMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:12:35 -0400
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20100512104138.GM7426@linux.vnet.ibm.com>
References: <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
	 <20100413183537.GA17538@redhat.com>
	 <20100415093506.GA2064@linux.vnet.ibm.com>
	 <20100419193139.GA24080@redhat.com>
	 <20100420124358.GA20675@linux.vnet.ibm.com>
	 <20100420153023.GA9351@redhat.com>
	 <20100421065948.GA5440@linux.vnet.ibm.com>
	 <20100421160515.GA11321@redhat.com>
	 <20100422133154.GA10776@linux.vnet.ibm.com>
	 <1273610603.1810.101.camel@laptop>
	 <20100512104138.GM7426@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 13:12:31 +0200
Message-ID: <1273662751.1626.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 16:11 +0530, Srikar Dronamraju wrote:
> > We can't hold mmap_sem (for either read or write -- read would be
> > sufficient to serialize against mmap/mremap/munmap) from atomic uprobe
> > context, what we can do is validate that there is a INT3 on that
> > particular address, a mremap/munmap/munmap+mmap will either end not
> > having a pte entry for the address, or not have the INT3.
> 
> Did you mean "We can hold mmap_sem?" Else I am not sure if we can
> traverse the vma. Infact alloc_page_vma() needs mmap_sem to be acquired.
> Please clarify? 

OK, so maybe I misunderstood, this is from the INT3 trap handler, right?

We can _not_ take a sleeping lock from trap context. Why would you want
the vma anyway?

