Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1EJLj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1EJLj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:39:27 -0400
Date: Tue, 10 May 2011 13:39:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes,x86: disable irq durinr optimized callback
Message-ID: <20110510113913.GA6779@jolsa.brq.redhat.com>
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
 <20110510104019.GF2400@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510104019.GF2400@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:40:19PM +0200, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > +	local_irq_save(flags);
> >  	preempt_disable();
> >  	if (kprobe_running()) {
> >  		kprobes_inc_nmissed_count(&op->kp);
> > @@ -1208,6 +1210,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
> >  		__this_cpu_write(current_kprobe, NULL);
> >  	}
> >  	preempt_enable_no_resched();
> > +	local_irq_restore(flags);
> 
> irq-disable is synonymous to preempt disable so the preempt_disable()/enable() 
> pair looks like superfluous overhead.

yes, there's correct patch already in the list here:
http://marc.info/?l=linux-kernel&m=130382756829695&w=2

thanks,
jirka

> 
> Thanks,
> 
> 	Ingo
