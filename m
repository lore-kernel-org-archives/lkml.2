Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2C2NCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:02:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2C2NCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:02:06 -0400
Date: Thu, 29 Mar 2012 09:01:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        jason.wessel@windriver.com
Subject: Re: [PATCH] x86 NMI: Be smarter about invoking panic() inside NMI
 handler.
Message-ID: <20120329130155.GJ18218@redhat.com>
References: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
 <CANz0V+5ayWh3-xR1i4nCqTGF+6x+f7mOeokEhCCXhvG3a3pFhw@mail.gmail.com>
 <20120327160601.GA19273@redhat.com>
 <CANz0V+7J=gN1_cH2jCnCSdQ=TnL9=2+S+6orBPPep=-tFN4p0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANz0V+7J=gN1_cH2jCnCSdQ=TnL9=2+S+6orBPPep=-tFN4p0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 03:19:56AM -0400, Andrei E. Warkentin wrote:
> Hi Don,
> 
> Thank you for your feedback!
> 
> 2012/3/27 Don Zickus <dzickus@redhat.com>:
> >
> > Hmm, if try_panic fails, then the cpu continues on executing code.  This
> > might further corrupt an already broken system.  So I don't think this
> > patch will work as is.
> >
> 
> I see what you are saying. I could make the argument that this kind
> of system corruption could occur anyway even if you did panic inside
> an IRQ context instead, but I would tend to agree that your proposed
> solution is much better than adding another panic interface.
> 
> > Perhaps instead of panic'ing in the NMI context, we use irq_work and panic
> > in an interrupt context instead.  We still get the system to stop (though
> > it might still execute some interrupts) and it will be out of the NMI
> > context.
> >
> > However, you will still run into a similar problem when in the
> > panic/reboot case we shutdown all the remote cpus and have them sitting in
> > a similar cpu_relax loop in the NMI context, while the panic'ing cpu
> > cleans things up.
> >
> 
> Sorry, could you clarify what you mean? How does this affect KDB usage?

I figured it would affect it the same way you described in your panic
scenario.  The machine panics and you are trying to break in with KDB.
The above issue just says the other cpus could block KDB from stopping all
the cpus much like your original issue.

But I will admit I didn't fully understand the original problem you were
trying to solve.

Cheers,
Don

> 
> A
