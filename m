Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0ETLXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:23:16 -0400
Received: from www.tglx.de ([62.245.132.106]:58151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab0ETLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:23:15 -0400
Date: Thu, 20 May 2010 13:23:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
cc: Sujit K M <sjt.kar@gmail.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after
 console_init
In-Reply-To: <201005201512.40304@zigzag.lvk.cs.msu.su>
Message-ID: <alpine.LFD.2.00.1005201317490.3368@localhost.localdomain>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com> <201005201423.09075@zigzag.lvk.cs.msu.su> <alpine.LFD.2.00.1005201225170.3368@localhost.localdomain> <201005201512.40304@zigzag.lvk.cs.msu.su>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Nikita V. Youshchenko wrote:

> > > Still questions:
> > >
> > > 1) why does that prevent klogd from working?
> >
> > Patch below.
> > ...
> > @@ -1084,18 +1084,8 @@ void release_console_mutex(void)
> >  #endif
> >  	}
> >  	console_locked = 0;
> > -	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
> >  	mutex_unlock(&console_mutex);
> 
> Hmm... that lock is taken inside loop body, then control goes out of loop 
> at 'break' statement, and then, if this line is deteled, lock is still 
> held at function return. Looks wrong.

Stupid me. Yes. Drop that line.
 
> > > 3) I believe that 8250 serial driver is aware of preempt-rt.
> > > Could you please comment on my "2.6.33.2-rt13: RFC: fix serial
> > > console" post to linux-rt-users list
> > > (http://eeek.borgchat.net/lists/linux-rt-users/msg05569.html)
> >
> > While that can work due to the trylock, it can introduce massive
> > latencies just in case some driver reports a status change or what
> > ever.
> 
> Isn't it better just manually disable console (with 'quiet' kernel command 
> line option) when running in production? This may be recommended in proper 
> guidelines.

No, anything which needs extra parameters for normal operation is
wrong as it affects users. 

Adding a "I'm debugging, I don't care" flag for developers is the
right thing to do.

Thanks,

	tglx

