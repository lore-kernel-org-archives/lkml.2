Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab1D1QUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:20:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1D1QUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:20:17 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=wom5GMh1gUkA:10 a=0i_OOtiXEx8A:10 a=Rj1_iGo3bfgA:10 a=8nJEP1OIZ-IA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=cm27Pg_UAAAA:8 a=ns7_q2kFr6Bo1dlllzUA:9 a=x8N9Q-lMftX-A-7Z64MA:7 a=wPNLvfGTeEIA:10 a=zv9_9hqRWm8A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Thu, 28 Apr 2011 11:20:15 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428162015.GA1927@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
 <1303998629.18763.149.camel@gandalf.stny.rr.com>
 <BANLkTikrXHvLhFH0A2LbpZ7sGBi0iOH+gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikrXHvLhFH0A2LbpZ7sGBi0iOH+gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):
> >>  void __secure_computing(int this_syscall)
> >>  {
> >> -     int mode = current->seccomp.mode;
> >> +     int mode = -1;
> >>       int * syscall;
> >> -
> >> +     /* Do we need an RCU read lock to access current's state? */
> >
> > I'm actually confused to why you are using RCU. What are you protecting.
> > Currently, I see the state is always accessed from current->seccomp. But
> > current should not be fighting with itself.
> >
> > Maybe I'm missing something.
> 
> I'm sure it's me that's missing something.  I believe the seccomp
> pointer can be accessed from:
> - current
> - via /proc/<pid>/seccomp_filter (read-only)
> 
> Given those cases, would it make sense to ditch the RCU interface for it?

ISTM you need them to protect the reader.

-serge
