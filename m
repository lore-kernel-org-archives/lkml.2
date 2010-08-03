Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0HCRtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:49:17 -0400
Received: from www.tglx.de ([62.245.132.106]:60438 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab0HCRtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:49:13 -0400
Date: Tue, 3 Aug 2010 19:48:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
 comment
In-Reply-To: <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1008031943400.3225@localhost.localdomain>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>  <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com>  <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com>
 <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1025026541-1280857702=:3225"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1025026541-1280857702=:3225
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 3 Aug 2010, Linus Torvalds wrote:

> Added Oleg and Thomas to the participants.
> 
> Oleg/Thomas: the whole thread is on lkml, but I'm quoting most of the
> relevant parts..
> 
> On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > A previous patch:
> >
> >        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
> >        Author: David Howells <dhowells@redhat.com>
> >        Date:   Thu Jul 29 12:45:55 2010 +0100
> >        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
> >
> > fixed the lockdep checks on __task_cred().  This has shown up a place in the
> > signalling code where a lock should be held - namely that
> > check_kill_permission() requires its callers to hold the RCU lock.
> 
> It's not just check_kill_permission(), is it? I thought we could do
> the "for_each_process()" loops with just RCU, rather than holding the
> whole tasklist_lock? So I _think_ that getting the RCU read-lock would
> make it possible to get rid of the tasklist_lock in there too? At
> least in kill_something_info().
> 
> Yes/no? What am I missing? This is an Oleg question, mainly.

Yes, almost all places in the kernel which hold tasklist_lock read
locked are safe with RCU. I started to work on that, but got
distracted.
 
Thanks,

	tglx
--8323328-1025026541-1280857702=:3225--
