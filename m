Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2BBUm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:42:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53923 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2BBUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:42:28 -0500
Date: Thu, 2 Feb 2012 12:42:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for
 simple self-deadlock
Message-ID: <20120202204206.GH2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202005553.GD29058@leaf>
 <20120202162017.GH2518@linux.vnet.ibm.com>
 <20120202195638.GA9279@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202195638.GA9279@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020220-3270-0000-0000-000003B0C4C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:56:38AM -0800, Josh Triplett wrote:
> On Thu, Feb 02, 2012 at 08:20:17AM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 01, 2012 at 04:55:54PM -0800, Josh Triplett wrote:
> > > On Wed, Feb 01, 2012 at 11:41:21AM -0800, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > It is illegal to have a grace period within a same-flavor RCU read-side
> > > > critical section, so this commit adds lockdep-RCU checks to splat when
> > > > such abuse is encountered.  This commit does not detect more elaborate
> > > > RCU deadlock situations.  These situations might be a job for lockdep
> > > > enhancements.
> > > 
> > > Since doing so also violates the prohibition on blocking within an RCU
> > > read-side critical section, wouldn't it suffice to call might_sleep() or
> > > equivalent, which also detects other problems?  (Obviously this doesn't
> > > apply to SRCU, but it applies to the other variants of RCU.)
> > 
> > Yes, but...
> > 
> > The advantage of the lockdep-RCU splat is that it gives you a better
> > hint as to where the RCU read-side critical section was entered, which
> > is very helpful when tracking these down, especially when they are
> > intermittent.
> 
> Ah, fair enough.
> 
> > And yes, I should also well check for the other variants of RCU read-side
> > critical section (other than RCU).  Done.
> 
> Oh?  What hadn't you checked for?

Things like synchronize_sched() in rcu_read_lock() critical section
and vice versa.

> > I also glued the strings together to promote grepability as you suggest
> > later.  (But I leave it to you to get checkpatch.pl upgraded -- it currently
> > warns about long lines, but not about strings split across lines.)
> 
> It theoretically shouldn't warn about long lines that consist only of a
> quoted string possibly followed by ',' or ');'; it has a check to ignore
> those.  After you glued the strings together, what did you end up with?

You are quite right -- it ignores the lines with long strings.

> As for adding a warning about strings broken across lines, that seems
> sensible.  Some quick grepping suggests that doing so would catch a pile
> of existing code, too.  Patch to follow momentarily.

Indeed, I might not be the only one to overgeneralize from the 80-character
warning.  ;-)

							Thanx, Paul

