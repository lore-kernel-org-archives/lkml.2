Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab0E0JNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:13:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:36439 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab0E0JNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:13:05 -0400
Date: Thu, 27 May 2010 17:11:26 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       john.williams@petalogix.com, tglx@linutronix.de, peter.fritzsche@gmx.de,
       anton@samba.org, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead
 local_irq_save/restore
Message-ID: <20100527091126.GB14906@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>
 <1274863724-14906-2-git-send-email-monstr@monstr.eu>
 <1274884963.22648.245.camel@gandalf.stny.rr.com>
 <20100526100805.171b3c48.akpm@linux-foundation.org>
 <1274893911.22648.246.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1274893911.22648.246.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 May 2010 09:11:29.0404 (UTC) FILETIME=[978FDBC0:01CAFD7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 01:11:51PM -0400, Steven Rostedt wrote:
> On Wed, 2010-05-26 at 10:08 -0700, Andrew Morton wrote:
> 
> > 
> > If a developer looks at atomic_add_return() and asks himself "why did
> > this use raw_local_irq_save()", the only way of answering that question
> > is to go groveling through the git logs, which is a right PITA if
> > you're trying to get some coding work done.
> > 
> > Guys, any time you add code which is non-obvious at the raw C level, it
> > *needs* a comment!
> 
> Totally agree!  I've gotten pretty good at adding comments to changes
> like this that I do. I need to get better at telling others to comment
> their work ;-)

Cc'ed Frederic Weisbecker

Seems like this issue has been raised before:
http://marc.info/?l=linux-kernel&m=126292794806169&w=2

I'm afraid this patch will trigger lockdep warning if atomic_inc()
is used in some locks.
