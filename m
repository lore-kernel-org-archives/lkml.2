Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1AFQGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:06:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752862Ab1AFQGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:06:36 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/4fKYrcen4lE9tkPPqQeoGFoOXlJK9pVBaiKDs7x
	fCGSuX2/zDC6gf
Date: Thu, 6 Jan 2011 17:06:29 +0100
From: torbenh <torbenh@gmx.de>
To: Dario Faggioli <raistlin@linux.it>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, john.stultz@linaro.org,
        roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
 process.
Message-ID: <20110106160629.GH32126@siel.b>
Mail-Followup-To: Dario Faggioli <raistlin@linux.it>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel <linux-kernel@vger.kernel.org>, john.stultz@linaro.org,
	roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>
References: <1293121303.3390.185.camel@Palantir>
 <1293533742.2899.1028.camel@Palantir>
 <20101228163829.GA26533@redhat.com>
 <1293572304.2899.1214.camel@Palantir>
 <20101229132130.GA16349@redhat.com>
 <20101230174529.GE2086@siel.b>
 <1294138885.6169.136.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294138885.6169.136.camel@Palantir>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 12:01:25PM +0100, Dario Faggioli wrote:
> On Thu, 2010-12-30 at 18:45 +0100, torbenh wrote: 
> > > I think we should change glibc if clock_getcpuclockid() doesn't work,
> > > please see below.
> > 
> > http://www.kernel.org/doc/man-pages/online/pages/man3/pthread_getcpuclockid.3.html
> > 
> > this one works.
> > ok... it takes a pthread_t for identifying the thread.
> > but it works.
> > 
> Well, I knew this, I knew it very well, as you can see from the code on
> the git I pointed to (it's part of one of the examples!).
> 
> the thing is that I believe there are situations where it could be
> useful to sample CLOCK_THREAD_CPUTIME_ID from a _different_ process, and
> in that case, you can't access that thread's pthread-id, can you? :-O
> 
> The jack2 code I saw could be one of these "potential user", and AFAICT
> your jack1 might be another one, no?
> Yeah, I know, whether you can/want use this or not also depends on other
> issues, but you are in a _different_ process --and thus you can't use
> pthread_* calls-- aren't you?

i would need to tell the tid to jackd anyways.
i could as well just communicate the clock_id. 

getting the clock_id into the other process is not a problem.
the problem is that i am not allowed to read out the clock.


> 
> I'm now looking at Oleg's solution and into glibc as well... I'll come
> out with something ASAP.
> 
> Regards,
> Dario
> 
> -- 
> <<This happens because I choose it to happen!>> (Raistlin Majere)
> ----------------------------------------------------------------------
> Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)
> 
> http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org



-- 
torben Hohn
