Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0ESOPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:15:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53715 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752487Ab0ESOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:15:08 -0400
Date: Wed, 19 May 2010 10:15:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>
Subject: Re: [PATCH v4 0/13] Uprobes v4
Message-ID: <20100519141458.GA3961@Krystal>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6> <20100518204944.GA6959@Krystal> <20100519060803.GB19957@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519060803.GB19957@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:10:56 up 116 days, 16:48,  9 users,  load average: 1.37, 1.03,
	1.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju (srikar@linux.vnet.ibm.com) wrote:
> > * Srikar Dronamraju (srikar@linux.vnet.ibm.com) wrote:
> > > Uprobes Patches
> > > 
> > > Changelog from v3:
> > >   - Reverted to background page replacement as suggested by Peter Zijlstra.
> > 
> > Why ?
> > 
> > I'm not sure we reached any concensus about the need for a background page
> > replacement.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> 
> I was tested with access_process_vm(previous patchset) and the current
> (background page replacement) and the results are the same. 
> 
> However Peter Zijlstra's contention still stands that we might be
> relying on a undocumented feature in the hardware

The access_process_vm scheme is in many ways similar to what kprobes has been
doing for years. So I would not rely on that as a primary argument against
the access_process_vm approach.

> and the flipping the
> pages isnt that hard or expensive.
> 
> Even Linus, (http://lkml.org/lkml/2010/1/27/87) had shown inclination
> towards background page replacement. 
> 
> Also when uprobes implements global tracing support (i.e probing a
> particular symbol in a dso across processes), it has to rely on
> background page replacement. 

Ah OK. If you have to use page replacement for global tracing, I see that as a
good argument for using page replacement everywhere.

> 
> Hence I based this patchset on background page replacement rather than
> on access_process_vm. Later On, if there is a consensus on using
> access_process_vm, we can make the corresponding changes.

Well, page replacement seems like a good way to support global tracing, so I
doubt that we'll ever revert back to access_process_vm.

Thanks,

Mathieu

> 
> --
> Thanks and Regards
> Srikar

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
