Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2JIRcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:32:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:39629 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab2JIRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:32:18 -0400
Date: Tue, 9 Oct 2012 19:32:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
In-Reply-To: <1349802833.24256.25.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210091925340.10988@ionos>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>  <1349795389.24256.20.camel@gandalf.local.home>  <alpine.LFD.2.02.1210091811540.10988@ionos> <1349802833.24256.25.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Steven Rostedt wrote:
> On Tue, 2012-10-09 at 18:19 +0200, Thomas Gleixner wrote:
> >  
> > > I've started looking at playing with the NAPI code again, and trying to
> > > see if I can add an ENAPI interface (Even Newer API), where the driver
> > > uses its own interrupt thread, and instead of having the polling in the
> > > network softirq, it can do the polling in its own thread.
> > 
> > It's pretty close to the behaviour I enforced with this change. Let's
> > play with that and figure out what influence it has on the network
> > throughput performance on RT. That needs probably a different
> > scheduling scheme than what Carsten needs for his deterministic
> > behaviour.
> > 
> 
> I was actually looking at the change for mainline, not for -rt ;-)

I know, but you can utilize RT for figuring out what kind of
performance impact (in whatever direction) this modus operandi
has. That gives us a better understanding and hopefully improvements
for RT, but at the same time a lot of insight in how we should handle
this scenario on a non RT kernel. You might try to make the softirq
split lock scheme work in CONFIG_RT_BASE as this gives us a way better
comparison to mainline behaviour.

Thanks,

	tglx
