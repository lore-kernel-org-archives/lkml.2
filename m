Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1FBVNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:13:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44941 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab1FBVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:13:09 -0400
Date: Thu, 2 Jun 2011 14:12:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, jmorris@namei.org,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 03/13] seccomp_filters: new mode with configurable
 syscall filters
Message-ID: <20110602211228.GO2271@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
 <1306897845-9393-3-git-send-email-wad@chromium.org>
 <20110602173654.GI2271@linux.vnet.ibm.com>
 <BANLkTi=vXXJzti_jn7kCA8jS9Q6uOej+yw@mail.gmail.com>
 <20110602194231.GL2271@linux.vnet.ibm.com>
 <BANLkTinrx7Ed9QPVOP=zJnr74nBBM_hLCw@mail.gmail.com>
 <1307047567.3667.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307047567.3667.27.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 04:46:07PM -0400, Steven Rostedt wrote:
> On Thu, 2011-06-02 at 15:28 -0500, Will Drewry wrote:
> 
> [ Snipped 860 lines of non relevant text ]
> 
> Seriously guys, Please trim your replies. These last few messages were
> ridicules. I spent more than 30 seconds searching for what the email was
> about. That's too much wasted time.

Because every time I do trim the messages, I get a response from the
reviewee of the form "Oh, I take care of that in function foo()."
And of course function foo() will be in the part I trimmed.  So I then
have to find the earlier message, copy the function back in, and by
that time something else has distracted me.

							Thanx, Paul

> -- Steve
> 
> 
> > >> Ah, I spaced on rcu_dereference().  The goal was to make the
> > >> assignment and replacement of the seccomp_filters pointer
> > >> RCU-protected (in seccomp_state) so there's no concern over it being
> > >> replaced partial on platforms where pointer assignments are non-atomic
> > >> - such as via /proc/<pid>/seccomp_filters access or a call via the
> > >> exported symbols.  Object lifetime is managed by reference counting so
> > >> that I don't have to worry about extending the RCU read-side critical
> > >> section by much or deal with pre-allocations.
> > >>
> > >> I'll add rcu_dereference() to all the get_seccomp_filters() uses where
> > >> it makes sense, so that it is called safely.  Just to make sure, does
> > >> it make sense to continue to rcu protect the specific pointer?
> > >
> > > It might.  The usual other options is to use a lock outside of the element
> > > containing the reference count to protect reference-count manipulation.
> > > If there is some convenient lock, especially if it is already held where
> > > needed, then locking is more straightforward.  Otherwise, RCU is usually
> > > a reasonable option.
> > 
> > I was concerned about the overhead a lock would have at each system
> > call entry, but I didn't benchmark it to see.  I'll add the
> > rcu_dereference right away, then look into seeing whether there's a
> > cleaner approach.  I was trying to be overly protective of mutating
> > any data internal to the filters through complete replacement on any
> > change.  I'll take a step back and see if
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
