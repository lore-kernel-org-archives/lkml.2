Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0ESGIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:08:13 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42982 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0ESGIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:08:12 -0400
Date: Wed, 19 May 2010 11:38:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/13] Uprobes v4
Message-ID: <20100519060803.GB19957@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
 <20100518204944.GA6959@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100518204944.GA6959@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Srikar Dronamraju (srikar@linux.vnet.ibm.com) wrote:
> > Uprobes Patches
> > 
> > Changelog from v3:
> >   - Reverted to background page replacement as suggested by Peter Zijlstra.
> 
> Why ?
> 
> I'm not sure we reached any concensus about the need for a background page
> replacement.
> 
> Thanks,
> 
> Mathieu
> 

I was tested with access_process_vm(previous patchset) and the current
(background page replacement) and the results are the same. 

However Peter Zijlstra's contention still stands that we might be
relying on a undocumented feature in the hardware and the flipping the
pages isnt that hard or expensive.

Even Linus, (http://lkml.org/lkml/2010/1/27/87) had shown inclination
towards background page replacement. 

Also when uprobes implements global tracing support (i.e probing a
particular symbol in a dso across processes), it has to rely on
background page replacement. 

Hence I based this patchset on background page replacement rather than
on access_process_vm. Later On, if there is a consensus on using
access_process_vm, we can make the corresponding changes.

--
Thanks and Regards
Srikar
