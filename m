Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0JPQcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:32:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0JPQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:32:10 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=nEQxJ46sMH0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=1Hv7G4Pumze-xx9hY4IA:9 a=ILAiYs52hs8_enR2rMUA:7 a=Iso8LrINrPF3ZXGBug8G22B9ZOMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace does not work on cpus > 999.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101016161627.GA3567@elte.hu>
References: <20101016131505.GW14064@sgi.com> <20101016144529.GA5384@nowhere>
	 <1287242272.16971.53.camel@gandalf.stny.rr.com>
	 <20101016161627.GA3567@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Oct 2010 12:32:08 -0400
Message-ID: <1287246728.16971.62.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 18:16 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Sat, 2010-10-16 at 16:45 +0200, Frederic Weisbecker wrote:
> > 
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 9ec59f5..3565f9e 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -3999,7 +3999,7 @@ static void tracing_init_debugfs_percpu(long cpu)
> > >  	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
> > >  	char cpu_dir[7];
> > >  
> > > -	if (cpu > 999 || cpu < 0)
> > > +	if (cpu < 0)
> > >  		return;
> > >  
> > >  	sprintf(cpu_dir, "cpu%ld", cpu);
> > 
> > You need to change the size of cpu_dir, otherwise this will overflow.
> 
> If you change it to 30 that ought to be enough, as long as cpu_id's fit 
> into u64. (I think we wont overflow that in my lifetime.)

And might as well make it static then, as we seem to be doing with
sched_param.

> 
> > The other case is to dynamically allocate cpu_dir.
> 
> Please tell me that is a joke ...

Why? It handles all cases and is only executed once at boot up. I'll
admit it was a little over engineered, and setting a new max of 30 chars
should be fine too. But no reason for it to be a joke.

-- Steve


