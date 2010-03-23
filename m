Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0CWP15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0CWP14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:27:56 -0400
Date: Tue, 23 Mar 2010 11:26:08 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100323152608.GC2975@redhat.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6> <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6> <1269342115.5279.1620.camel@twins> <20100323122335.GB26762@linux.vnet.ibm.com> <1269352012.5109.22.camel@twins> <20100323150544.GA18323@in.ibm.com> <1269357354.5109.83.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269357354.5109.83.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > Now the question is, where the complexity needs to be.
> 
> Both in-tree consumers of uprobes (ftrace and perf) are capable of task
> filters. [...]

If you wish this new uprobes to be useful to tools such as gdb,
remember the value of preserving the property that processes not being
debugged are not to be interfered with.  You don't want a DoS due to
some guy setting ten thousand breakpoints on glibc.  Such
considerations should overrule perf/ftrace's simplifying assumptions
that after-the-fact event filtering is surely always sufficient.

- FChE
