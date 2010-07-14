Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0GNWH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:07:26 -0400
Received: from smtp3.Stanford.EDU ([171.67.219.83]:40392 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757351Ab0GNWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:07:23 -0400
Subject: Re: 2.6.33.5 rt23: sleeping function called from invalid context
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278639872.3008.36.camel@localhost.localdomain>
References: <1278561270.5448.2.camel@localhost.localdomain>
	 <1278610624.3008.2.camel@localhost.localdomain>
	 <1278639872.3008.36.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 15:06:51 -0700
Message-ID: <1279145211.3018.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 18:44 -0700, john stultz wrote:
> On Thu, 2010-07-08 at 10:37 -0700, john stultz wrote:
> > On Wed, 2010-07-07 at 20:54 -0700, Fernando Lopez-Lezcano wrote:
> > > After a suspend/wake up cycle, just after upgrading to fc12 (I did not
> > > see this with the same basic kernel - that is, compiled from the same
> > > source + patches - under fc11). 
> > > 
> > > BUG: sleeping function called from invalid context at
> > > kernel/rtmutex.c:684
> > > pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 10582, name:
> > > pm-suspend
> > > Pid: 10582, comm: pm-suspend Not tainted
> > > 2.6.33.5-120.rt23.1.fc11.ccrma.i686.rtPAE #1
> > > Call Trace:
> > > [<c042eced>] __might_sleep+0xcc/0xd4
> > > [<c0464f57>] rt_spin_lock_fastlock.clone.1+0x26/0x5f
> > > [<c0792862>] rt_spin_lock+0x8/0xa
> > > [<c040dddc>] read_persistent_clock+0x11/0x30
> > > [<c045d1de>] timekeeping_suspend+0xe/0x4e
> > > [<c0640c9e>] sysdev_suspend+0x15c/0x356
> > > [<c0792906>] ? _mutex_unlock+0x8/0xa
> > > [<c046afc1>] suspend_devices_and_enter+0xea/0x17f
> > 
> > Huh. Looks like the lock protecting the RTC/CMOS might need to be
> > converted to a raw spinlock, since suspend/resume is probably done with
> > irqs off.
> 
> Oof. The rtc_lock is used all over the place. Not sure if we really want
> to convert it to a raw_spinlock. 
> 
> However, sysdev_suspend() wants interrupts off on all the .suspend
> calls. I'm surprised we haven't hit this issue with more drivers. Maybe
> no one is testing suspend w/ -rt? Or am I just missing an obvious
> solution?
> 
> Thomas, any thoughts on this? 

(BTW, this is still happening in rt26...)
-- Fernando



