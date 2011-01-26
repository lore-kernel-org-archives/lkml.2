Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1AZKM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:12:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:43180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AZKM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:12:57 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110126084103.GE19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
	 <1295957742.28776.720.camel@laptop>
	 <20110126084103.GE19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 11:13:21 +0100
Message-ID: <1296036801.28776.1140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:11 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-01-25 13:15:42]:
> 
> > On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> > > +/* Should be called lock-less */
> > > +static void put_uprobe(struct uprobe *uprobe)
> > > +{
> > > +       if (atomic_dec_and_test(&uprobe->ref))
> > > +               kfree(uprobe);
> > > +} 
> > 
> > Since this instantly frees the uprobe once ref hits 0, the
> > atomic_inc_not_zero() in find_uprobe() doesn't really make sense does
> > it?
> 
> Okay, I can move the atomic_inc_not_zero() in find_uprobe() to
> atomic_inc().
> 
> Do you see any side-effects of using atomic_inc_not_zero?

No, its just slower, once you want to start doing RCU lookups in the
probe tree you'll need it through.
