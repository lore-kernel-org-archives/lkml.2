Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0EMToX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:44:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0EMToV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:44:21 -0400
Date: Thu, 13 May 2010 21:40:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
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
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100513194034.GA11207@redhat.com>
References: <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com> <20100420153023.GA9351@redhat.com> <20100421065948.GA5440@linux.vnet.ibm.com> <20100421160515.GA11321@redhat.com> <20100422133154.GA10776@linux.vnet.ibm.com> <20100422154059.GA5916@redhat.com> <1273610723.1810.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273610723.1810.105.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Peter Zijlstra wrote:
>
> On Thu, 2010-04-22 at 17:40 +0200, Oleg Nesterov wrote:
> >
> > Either way, I think register_uprobe() should disallow the probes in
> > VM_SHARED/VM_MAYWRITE vmas.
>
> VM_SHARED, fully agreed, MAYWRITE not so sure, MAP_PRIVATE has MAYWRITE
> iirc and its perfectly fine to poke at those.

Yes, sorry for confusion. Not sure where this VM_MAYWRITE came from.

But I still think this doesn't actually matter, replace_page() shouldn't
preserve the mapping, it should always install the anonymous page. I can
be wrong, of course.

(I didn't read the next version yet)

Oleg.

