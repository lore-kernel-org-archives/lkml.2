Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2LQRJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:09:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2LQRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:09:39 -0500
Message-ID: <1355764176.11540.19.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Mon, 17 Dec 2012 18:09:36 +0100
In-Reply-To: <alpine.LFD.2.02.1212171634070.3148@ionos>
References: <alpine.LFD.2.02.1212051659160.2701@ionos>
	 <1355543529.20987.6.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1212171634070.3148@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:c8wncz/YCczQJTsgqzh25SsbQN3egkHlJ8dd66I/XhK
 N4YgR+xBNIae3wjaEOzWo82yXmWi41zRecJEeKY/vCJExLX4cb
 cZB23EKBIQKjM8HqkXQltcIetF8T+iUFSEr4o89L75Z8hVDVXJ
 L8xFZVRZuHu1aoTA9VPXWhwcmAuWAEGWhTp3ia1rVizF5NR1eq
 SMqegV55WJxtkilO4X+QpErzkVjTAW1hrKBe+nBMaTblzhNtxf
 g4IfquAtBYnWGWzLBRpofjZGOIXmpdtz6boflJ/fpyLv3eLrSz
 VbLxt0IihpPbqnsiWgJjfcaO9JV4U15xYtk8KKpkeaviSPE2n0
 vldvjJuXQAcTe3Lo78gUQAVhaKAVFYaNl4rHomMqhizxDje+QY
 TPCllnMEpPsmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 16:35 +0100, Thomas Gleixner wrote: 
> On Sat, 15 Dec 2012, Mike Galbraith wrote:
> > On Wed, 2012-12-05 at 17:05 +0100, Thomas Gleixner wrote: 
> > > Dear RT Folks,
> > > 
> > > I'm pleased to announce the 3.6.9-rt21 release. 3.6.7-rt18, 3.6.8-rt19
> > > and 3.6.9-rt20 are not announced updates to the respective 3.6.y
> > > stable releases without any RT changes
> > > 
> > > Changes since 3.6.9-rt20:
> > > 
> > >    * Fix the PREEMPT_LAZY implementation on ARM
> > > 
> > >    * Fix the RCUTINY issues
> > > 
> > >    * Fix a long standing scheduler bug (See commit log of
> > >      sched-enqueue-to-head.patch)
> > 
> > That last has an oversight buglet.
> > 
> > sched: add missing userspace->kernel struct sched_param.sched_priority inversion
> > 
> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > ---
> >  kernel/sched/core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4624,7 +4624,7 @@ static int __sched_setscheduler(struct t
> >  	p->sched_reset_on_fork = reset_on_fork;
> >  
> >  	oldprio = p->prio;
> > -	if (oldprio == param->sched_priority)
> > +	if (oldprio == (MAX_RT_PRIO - 1) - param->sched_priority)
> >  		goto out;
> >  
> >  	on_rq = p->on_rq;
> 
> Duh, yes. But there is another one here:
> 
> +               enqueue_task(rq, p, oldprio < param->sched_priority ?
> +                            ENQUEUE_HEAD : 0);
> 
> Bah. This reverse user/kernel priority nonsense really should go away!

Snort, I looked right at it too, looked perfectly fine :)

-Mike

