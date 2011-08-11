Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab1HKQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:22:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41329 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1HKQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:22:51 -0400
Date: Thu, 11 Aug 2011 18:22:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110811162245.GL23842@htj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
 <20110810214444.GD9320@atrey.karlin.mff.cuni.cz>
 <20110811160914.GA8985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811160914.GA8985@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 11, 2011 at 06:09:14PM +0200, Oleg Nesterov wrote:
> On 08/10, Pavel Machek wrote:
> >
> > > CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> > > This is obviously not good, it is sooo simple to create the task which
> > > doesn't react to SIGKILL/SIGSTOP.
> > >
> > > Questions:
> > >
> > > 	- do we really need this?
> > >
> > I believe we should fix it. I was always claiming "if it does not
> > react to SIGKILL, it is a kernel bug" and well, this just proved me
> > wrong...
> 
> Agreed.
> 
> Just in case... sorry to all for delay, I am busy. I'll try to resend
> the simplified version "soon", at least the "unkillable" part. And
> we also have the pending oom issues...

I'm currently trying to handle both vfork and cgroup freezes as jobctl
stop so that all three different stop modes - group stop, vfork wait
and cgroup freeze - share the same characteristics.  I'm currently
somewhat stuck with some freezer and kthread issues I discovered in
the process and it seems like it would take some time.

Thanks.

-- 
tejun
