Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1EJLo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:44:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1EJLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:44:28 -0400
Date: Tue, 10 May 2011 13:44:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes,x86: disable irq durinr optimized callback
Message-ID: <20110510114418.GB24786@elte.hu>
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
 <20110510104019.GF2400@elte.hu>
 <20110510113913.GA6779@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510113913.GA6779@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, May 10, 2011 at 12:40:19PM +0200, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > +	local_irq_save(flags);
> > >  	preempt_disable();
> > >  	if (kprobe_running()) {
> > >  		kprobes_inc_nmissed_count(&op->kp);
> > > @@ -1208,6 +1210,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
> > >  		__this_cpu_write(current_kprobe, NULL);
> > >  	}
> > >  	preempt_enable_no_resched();
> > > +	local_irq_restore(flags);
> > 
> > irq-disable is synonymous to preempt disable so the preempt_disable()/enable() 
> > pair looks like superfluous overhead.
> 
> yes, there's correct patch already in the list here:
> http://marc.info/?l=linux-kernel&m=130382756829695&w=2

It helps to change the subject line when you think another patch should be 
considered, to something like:

  [PATCH, v2] kprobes, x86: Disable irq during optimized callback

(also note the other changes i made to the title, 3 altogether.)

Thanks,

	Ingo
