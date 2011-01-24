Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1AXMwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:52:02 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46918 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751861Ab1AXMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:52:01 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/HB0kv2g3He8LBpuqU5C0gAvC8qUcJMDf0cKR2Fk
	PPLFrK3KfMAIsr
Date: Mon, 24 Jan 2011 13:51:52 +0100
From: torbenh <torbenh@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 09/18] frv: switch do_timer() to xtime_update()
Message-ID: <20110124125152.GA29377@siel.b>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
	hch@infradead.org, yong.zhang0@gmail.com
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
 <1295651224-29823-10-git-send-email-torbenh@gmx.de>
 <alpine.LFD.2.00.1101221051570.2971@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101221051570.2971@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 11:01:49AM +0100, Thomas Gleixner wrote:
> On Sat, 22 Jan 2011, Torben Hohn wrote:
> 
> > this code looks like its protecting __set_LEDS() with this lock also.
> > i dont think thats necessary.
> 
> This changelog is horrible. 

agreed.
what i meant was that: if i do something while holding a lock,
it seems to be necessary to do it while holding the lock.


> 
> This code does not look like protecting the __set_LEDS() call with the
> xtime_lock. The call happens to be inside the xtime_lock held region.
> 
> Now instead of bringing up a weak argument "I dont think ..." you
> should provide a proper analysis why it's safe to move that code out.
> 
> It's pretty simple:
> 
> No other call site of __set_LEDS() is protected by xtime_lock, so
> xtime_lock does not protect anything related to __set_LEDS(). It's
> just inside the xtime_lock region for no good reason at all.
> 
> Please be more careful when writing change logs, so a reviewer can
> understand the reasoning behind your change easily.

ok. will do.

> 
> Also all arch/* patches are missing a "Cc: arch-maintainer@somewhere.xxx".

i was planning to send it out with --cc-cmd=./scripts/get_maintainers.pl
once you thought it was ok.
is that procedure ok ?
or should i add CC: lines to the commitlogs ?


> 
> >  {
> > @@ -61,10 +61,11 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
> >  	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
> >  	 * the irq version of write_lock because as just said we have irq
> >  	 * locally disabled. -arca
> > +	 *
> > +	 * xtime_update takes the writelock.
> 
>   Errm. xtime_update write locks xtime_lock. Please be careful with comments.

ok

> 
> Thanks,
> 
> 	tglx

-- 
torben Hohn
