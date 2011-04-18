Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1DRRda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:33:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1DRRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:33:25 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=eB1xKnnnCBQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=HiHOTtR78ZVs8Wu2-TQA:9 a=leDIBe4hL-LKxSe1mm0A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 4/7] lockdep: Seperate lock ids for read/write
 acquires
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303145378.32491.889.camel@twins>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.123045423@chello.nl>
	 <1303145177.7181.46.camel@gandalf.stny.rr.com>
	 <1303145378.32491.889.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 13:33:22 -0400
Message-ID: <1303148002.7181.47.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 18:49 +0200, Peter Zijlstra wrote:
> On Mon, 2011-04-18 at 12:46 -0400, Steven Rostedt wrote:
>  
> > >  void lockdep_off(void)
> > > @@ -1988,6 +1988,9 @@ static void check_chain_key(struct task_
> > >               if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
> > >                       return;
> > >  
> > > +             if (is_read(hlock->rw_state))
> > > +                     id += MAX_LOCKDEP_KEYS;
> > 
> > Again, isn't this about recursive reads? Or am I just confused ;) 
> 
> So what we do here is split off the write chain, the above could have
> been writeen if (!is_write()) to clarify that.

Or just add a comment ;)

-- Steve

> 
> Everything except recursive read validation will traverse both chains,
> the recursive read validation will only traverse the write chains and
> ignore the combined read/recursive-read chain.


