Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2BBT4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:56:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54713 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab2BBT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:56:52 -0500
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 11:56:38 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for
 simple self-deadlock
Message-ID: <20120202195638.GA9279@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202005553.GD29058@leaf>
 <20120202162017.GH2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202162017.GH2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 08:20:17AM -0800, Paul E. McKenney wrote:
> On Wed, Feb 01, 2012 at 04:55:54PM -0800, Josh Triplett wrote:
> > On Wed, Feb 01, 2012 at 11:41:21AM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > It is illegal to have a grace period within a same-flavor RCU read-side
> > > critical section, so this commit adds lockdep-RCU checks to splat when
> > > such abuse is encountered.  This commit does not detect more elaborate
> > > RCU deadlock situations.  These situations might be a job for lockdep
> > > enhancements.
> > 
> > Since doing so also violates the prohibition on blocking within an RCU
> > read-side critical section, wouldn't it suffice to call might_sleep() or
> > equivalent, which also detects other problems?  (Obviously this doesn't
> > apply to SRCU, but it applies to the other variants of RCU.)
> 
> Yes, but...
> 
> The advantage of the lockdep-RCU splat is that it gives you a better
> hint as to where the RCU read-side critical section was entered, which
> is very helpful when tracking these down, especially when they are
> intermittent.

Ah, fair enough.

> And yes, I should also well check for the other variants of RCU read-side
> critical section (other than RCU).  Done.

Oh?  What hadn't you checked for?

> I also glued the strings together to promote grepability as you suggest
> later.  (But I leave it to you to get checkpatch.pl upgraded -- it currently
> warns about long lines, but not about strings split across lines.)

It theoretically shouldn't warn about long lines that consist only of a
quoted string possibly followed by ',' or ');'; it has a check to ignore
those.  After you glued the strings together, what did you end up with?

As for adding a warning about strings broken across lines, that seems
sensible.  Some quick grepping suggests that doing so would catch a pile
of existing code, too.  Patch to follow momentarily.

- Josh Triplett
