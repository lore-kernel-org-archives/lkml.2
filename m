Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1FBUqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:46:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1FBUqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:46:10 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=S8JHbHfjElkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hStVlmBtej1G5Gl7sPoA:9 a=IZ5dSOD89ANXS8pK6xIA:7 a=PUjeQqilurYA:10 wl=env:18 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v3 03/13] seccomp_filters: new mode with configurable
 syscall filters
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, jmorris@namei.org,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-security-module@vger.kernel.org
In-Reply-To: <BANLkTinrx7Ed9QPVOP=zJnr74nBBM_hLCw@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
	 <1306897845-9393-3-git-send-email-wad@chromium.org>
	 <20110602173654.GI2271@linux.vnet.ibm.com>
	 <BANLkTi=vXXJzti_jn7kCA8jS9Q6uOej+yw@mail.gmail.com>
	 <20110602194231.GL2271@linux.vnet.ibm.com>
	 <BANLkTinrx7Ed9QPVOP=zJnr74nBBM_hLCw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Jun 2011 16:46:07 -0400
Message-ID: <1307047567.3667.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 15:28 -0500, Will Drewry wrote:

[ Snipped 860 lines of non relevant text ]

Seriously guys, Please trim your replies. These last few messages were
ridicules. I spent more than 30 seconds searching for what the email was
about. That's too much wasted time.

-- Steve


> >> Ah, I spaced on rcu_dereference().  The goal was to make the
> >> assignment and replacement of the seccomp_filters pointer
> >> RCU-protected (in seccomp_state) so there's no concern over it being
> >> replaced partial on platforms where pointer assignments are non-atomic
> >> - such as via /proc/<pid>/seccomp_filters access or a call via the
> >> exported symbols.  Object lifetime is managed by reference counting so
> >> that I don't have to worry about extending the RCU read-side critical
> >> section by much or deal with pre-allocations.
> >>
> >> I'll add rcu_dereference() to all the get_seccomp_filters() uses where
> >> it makes sense, so that it is called safely.  Just to make sure, does
> >> it make sense to continue to rcu protect the specific pointer?
> >
> > It might.  The usual other options is to use a lock outside of the element
> > containing the reference count to protect reference-count manipulation.
> > If there is some convenient lock, especially if it is already held where
> > needed, then locking is more straightforward.  Otherwise, RCU is usually
> > a reasonable option.
> 
> I was concerned about the overhead a lock would have at each system
> call entry, but I didn't benchmark it to see.  I'll add the
> rcu_dereference right away, then look into seeing whether there's a
> cleaner approach.  I was trying to be overly protective of mutating
> any data internal to the filters through complete replacement on any
> change.  I'll take a step back and see if
> 


