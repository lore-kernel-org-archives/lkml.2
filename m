Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1D1THZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:07:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab1D1THU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:07:20 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=0i_OOtiXEx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cm27Pg_UAAAA:8 a=Onhg2s7Uw6P4liCpctwA:9 a=PUjeQqilurYA:10 a=zv9_9hqRWm8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <20110428185416.GB13071@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-2-git-send-email-wad@chromium.org>
	 <20110428165525.GB1927@hallyn.com>
	 <1304010981.18763.192.camel@gandalf.stny.rr.com>
	 <20110428173957.GA25940@hallyn.com>
	 <BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
	 <1304014874.18763.201.camel@gandalf.stny.rr.com>
	 <BANLkTimg==qTO2=1VaeXFM8Gt5R_VFYLCA@mail.gmail.com>
	 <20110428185416.GB13071@hallyn.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 15:07:18 -0400
Message-ID: <1304017638.18763.205.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 13:54 -0500, Serge E. Hallyn wrote:
> Quoting Will Drewry (wad@chromium.org):
> > My intent was to make them available for use by seccomp.c during state
> > teardown/dup.  I don't think there's benefit to exposing them outside
> > of that.  Would dropping the export, and adding an local seccomp.h
> > with the shared functions in them resolve that more cleanly?
> 
> And add a clear comment explaining :)

Yes that always helps.

> 
> > > Your code would have been correct if you could call kzalloc under
> > > rcu_read_lock() (which you can on some kernel configurations but not
> > > all). The issue is that you need to pull out that allocation from the
> > > rcu_read_lock() because rcu_read_lock assumes you can't preempt, and
> > > that allocation can schedule out. The access to the filters must be done
> > > under rcu_read_lock(), other than that, you're fine.
> > 
> > That makes sense.  I think I'd prefer to not share those functions
> > rather than guard the list just in case a future consumer of the
> > interface comes along.  Would that make sense to you?  Since I don't
> > see any other users right now other than seccomp.c, it might make
> > sense to tackle the impact when an actual need arises.
> > 
> > I'll go whichever way pointed on this, though.
> 
> Complicating the locking for nonexistent users doesn't seem like the
> right way.

I agree.

-- Steve


