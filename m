Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab0E0RYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:24:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50580 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0E0RYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:24:01 -0400
Date: Thu, 27 May 2010 18:23:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527172343.GB2468@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:15:31PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > You still need the in-kernel suspend blockers if you want to guarantee 
> > that you can't lose wakeup events. But yes, if you're not concerned 
> > handling badly behaved applications then I believe that you can lose 
> > opportunistic suspend and just use the scheduler.
> 
> No, we do not. We need correctly implemented drivers and a safe
> switchover from normal event delivery to wakeup based.

What is a "Correctly implemented driver" in this case? One that receives 
a wakeup event and then prevents suspend being entered until userspace 
has acknowledged that event? Because that's what an in-kernel suspend 
blocker is.

> > My question was about explicit suspend states, not implicitly handling 
> > an identical state based on scheduler constraints. Suspend-as-a-C-state 
> > isn't usable on x86 - you have to explicitly trigger it based on some 
> 
> And why not ? Just because suspend is not implemented as an ACPI
> C-state ? 
> 
> Nonsense, if we want to push the system into suspend from the idle
> state we can do that. It's just not implemented and we've never tried
> to do it as it requires a non trivial amount of work, but I have done
> it on an ARM two years ago as a prove of concept and it works like a
> charm.

ACPI provides no guarantees about what level of hardware functionality 
remains during S3. You don't have any useful ability to determine which 
events will generate wakeups. And from a purely practical point of view, 
since the latency is in the range of seconds, you'll never have a low 
enough wakeup rate to hit it.

> > policy. And if you want to be able to do that without risking the loss 
> > of wakeup events then you need in-kernel suspend blockers.
> 
> Crap. Stop beating on those lost wakeup events. If we lose them then
> the drivers are broken and do not handle the switch over correctly. Or
> the suspend mechanism is broken as it does not evaluate the system
> state correctly. Blockers are just papering over that w/o tackling the
> real problem.

Ger;kljaserf;kljf;kljer;klj. Suspend blockers are the mechanism for the 
driver to indicate whether the wakeup event has been handled. That's 
what they're there for. The in-kernel ones don't paper over anything.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
