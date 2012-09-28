Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030928Ab2I1TMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030670Ab2I1TGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:04 -0400
Date: Fri, 28 Sep 2012 15:05:52 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.6-rc4
Message-ID: <20120928190552.GA32188@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <levinsasha928@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
 <20120904154412.GA14321@redhat.com>
 <504A3527.9070104@gmail.com>
 <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com>
 <1347287780.2124.10.camel@twins>
 <20120921211639.GA17379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921211639.GA17379@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:16:39PM -0400, Dave Jones wrote:
 > On Mon, Sep 10, 2012 at 04:36:20PM +0200, Peter Zijlstra wrote:
 >  > On Fri, 2012-09-07 at 11:39 -0700, Linus Torvalds wrote:
 >  > > Al? Please look into this. I'm not entirely sure what's going on, but
 >  > > lockdep complains about this:
 >  > > 
 >  > >  Possible interrupt unsafe locking scenario:
 >  > > 
 >  > >        CPU0                    CPU1
 >  > >        ----                    ----
 >  > >   lock(&(&p->alloc_lock)->rlock);
 >  > >                                local_irq_disable();
 >  > >                                lock(&(&new_timer->it_lock)->rlock);
 >  > >                                lock(tasklist_lock);
 >  > >   <Interrupt>
 >  > >     lock(&(&new_timer->it_lock)->rlock);
 >  > > 
 >  > >  *** DEADLOCK ***
 >  > > 
 >  > > and it looks real. IOW, if I read that right, we have the task_lock ->
 >  > > it_lock dependency through exit_itimers(), and then we have the
 >  > > tasklist_lock -> task_lock dependency everywhere else. So now it_lock
 >  > > -> tasklist_lock becomes a deadlock. 
 >  > 
 >  > Agreed, I've got the following series from Oleg queued to solve this:
 >  > 
 >  >  http://marc.info/?l=linux-kernel&m=134600821828491&w=2
 > 
 > What's happening with this series ? I'm still seeing these traces in rc6.

and still in rc7.

Peter ?

	Dave
