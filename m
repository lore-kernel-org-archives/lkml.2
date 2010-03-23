Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0CWPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:17:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0CWPQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:16:59 -0400
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20100323150544.GA18323@in.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
	 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
	 <1269342115.5279.1620.camel@twins>
	 <20100323122335.GB26762@linux.vnet.ibm.com>
	 <1269352012.5109.22.camel@twins>  <20100323150544.GA18323@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:15:54 +0100
Message-ID: <1269357354.5109.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 20:35 +0530, Ananth N Mavinakayanahalli wrote:
> Now the question is, where the complexity needs to be.

Both in-tree consumers of uprobes (ftrace and perf) are capable of task
filters.

But the thing is, dso:sym is very much not a task property, adding task
filters afterwards sure makes sense in some cases but it should not be
the primary mode.

If people really want to optimize this we can easily add a few bits of
task state which could tell the trap handler to not even bother looking
up things but restart as fast as possible.
