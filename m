Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0ICUKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab0ICUKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:10:42 -0400
Date: Fri, 3 Sep 2010 16:10:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf, x86: Fix accidentally ack'ing a second
 event on intel perf counter
Message-ID: <20100903201024.GF4879@redhat.com>
References: <1283454469-1909-2-git-send-email-dzickus@redhat.com>
 <tip-2e556b5b320838fde98480a1f6cf220a5af200fc@git.kernel.org>
 <4C80A62D.6050901@kernel.org>
 <20100903150055.GY4879@redhat.com>
 <4C812D24.8000704@kernel.org>
 <20100903183559.GB4879@redhat.com>
 <4C814B59.1030109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C814B59.1030109@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 12:24:09PM -0700, Yinghai Lu wrote:
> > Let me know if this meets your needs.
> it should work. will test later
> > 
> > Cheers,
> > Don
> > 
> > @@ -371,6 +381,10 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >  			reason, smp_processor_id());
> >  
> >  	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
> > +#if defined(CONFIG_SYSCTL) && defined(CONFIG_X86_LOCAL_APIC)
> > +	if (unknown_nmi_panic)
> > +		die_nmi("", regs, 1);
> > +#endif
> 
> can you move it before the two printk(KERN_EMERG...)?

Well, then you do not print a reason for the panic.  Though the one printk
might not be useful.

> 
> >  	if (panic_on_unrecovered_nmi)
> >  		panic("NMI: Not continuing");
> 
> Can you merge those two panic? 

I thought about it but did not want to disturb the panic vs die_nmi paths.
But I can definitely do that I think.

Cheers,
Don
