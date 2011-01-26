Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1AZIrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:47:43 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59787 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1AZIrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:47:42 -0500
Date: Wed, 26 Jan 2011 14:11:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
Message-ID: <20110126084103.GE19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
 <1295957742.28776.720.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295957742.28776.720.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 13:15:42]:

> On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> > +/* Should be called lock-less */
> > +static void put_uprobe(struct uprobe *uprobe)
> > +{
> > +       if (atomic_dec_and_test(&uprobe->ref))
> > +               kfree(uprobe);
> > +} 
> 
> Since this instantly frees the uprobe once ref hits 0, the
> atomic_inc_not_zero() in find_uprobe() doesn't really make sense does
> it?

Okay, I can move the atomic_inc_not_zero() in find_uprobe() to
atomic_inc().

Do you see any side-effects of using atomic_inc_not_zero?

-- 
Thanks and Regards
Srikar
