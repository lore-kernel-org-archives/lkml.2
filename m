Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab2DFX7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:59:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:40617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2DFX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:59:31 -0400
Date: Sat, 7 Apr 2012 01:59:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timer updates for 3.4-rc
In-Reply-To: <20120406165824.c2ae2719.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1204070159160.2542@ionos>
References: <alpine.LFD.2.02.1204070131010.2542@ionos> <alpine.DEB.2.00.1204061636260.32765@chino.kir.corp.google.com> <alpine.LFD.2.02.1204070148420.2542@ionos> <20120406165824.c2ae2719.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andrew Morton wrote:

> On Sat, 7 Apr 2012 01:48:51 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 6 Apr 2012, David Rientjes wrote:
> > 
> > > On Sat, 7 Apr 2012, Thomas Gleixner wrote:
> > > 
> > > > diff --git a/kernel/itimer.c b/kernel/itimer.c
> > > > index 22000c3..c70369a 100644
> > > > --- a/kernel/itimer.c
> > > > +++ b/kernel/itimer.c
> > > > @@ -284,8 +284,11 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
> > > >  	if (value) {
> > > >  		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
> > > >  			return -EFAULT;
> > > > -	} else
> > > > +	} else {
> > > >  		memset((char *) &set_buffer, 0, sizeof(set_buffer));
> > > > +		WARN_ONCE(1, "setitimer: new_value pointer is NULL."
> > > > +			  " Misfeature support will be removed\n");
> > > > +	}
> > > >  
> > > >  	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
> > > >  	if (error || !ovalue)
> > > 
> > > When I tried doing this for the deprecated /proc/pid/oom_adj there was a 
> > > complaint that WARN_ONCE() screws up log parsing scripts that think there 
> > > is a kernel issue so I had to change it to printk_once() and include 
> > > get_task_comm(current) and current->pid.  See
> > > http://lkml.indiana.edu/hypermail/linux/kernel/1108.0/00446.html
> > 
> > Bah.
> 
> It gives you a chance to remove the unneeded cast from the memset call ;)

Will do :)
 
