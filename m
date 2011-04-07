Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1DGFxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:53:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1DGFxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:53:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/mutex.c
Date: Thu, 7 Apr 2011 07:53:47 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Xiaotian Feng <dfeng@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <4D970CB6.3070604@redhat.com> <201104060643.38301.rjw@sisk.pl> <1302077253.2225.1360.camel@twins>
In-Reply-To: <1302077253.2225.1360.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104070753.47431.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 06, 2011, Peter Zijlstra wrote:
> On Wed, 2011-04-06 at 06:43 +0200, Rafael J. Wysocki wrote:
> > > the $subject text sound like it triggered might_sleep(), and that had a
> > > system_state != SYSTEM_RUNNING bail condition, but then, I've no clue
> > > what resume looks like.
> > 
> > Early resume looks pretty much like the system startup, e.g. everything
> > called from syscore_ops should not be sleepable (although mutexes shouldn't
> > trigger, because that code is effectively single-threaded, unless somebody
> > holds the mutex in question when that code is being executed, but that would
> > deadlock anyway). 
> 
> Right, so system_state != SYSTEM_RUNNING should be true for resume?

It is not, although it probably should be.

First, some time ago there was opposition to adding more different possible
values of system_state and it wasn't clear which of the existing values should
be used instead of SYSTEM_RUNNING during suspend/resume.  We ended up sticking
to SYSTEM_RUNNING for that reason long enough for some code to develop the
expectation of system_state == SYSTEM_RUNNING during suspend/resume (IOW,
changing that right now would probably break stuff).

Second, even if we decide to switch from SYSTEM_RUNNING to something else
during suspend (and back during resume), it's not entirely clear what's the
right place to do so.

Thanks,
Rafael
