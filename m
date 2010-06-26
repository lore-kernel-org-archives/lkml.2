Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0FZVoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 17:44:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753757Ab0FZVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 17:44:08 -0400
Date: Sat, 26 Jun 2010 23:43:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>, linux-kernel@vger.kernel.org,
       sboyd@codeaurora.org, tglx@linutronix.de, mingo@elte.hu,
       heiko.carstens@de.ibm.com, eranian@google.com, schwidefsky@de.ibm.com,
       linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
Message-ID: <20100626214359.GA1773@elf.ucw.cz>
References: <4C225EED.5040600@codeaurora.org>
 <1277323537.15159.30.camel@c-dwalke-linux.qualcomm.com>
 <4C226CCA.20601@codeaurora.org>
 <1277326605.15159.70.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277326605.15159.70.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, this test was leftover from a different project that involved refactoring
> > timers, so it was available and easy.  My guess for the reduction in number of
> > wakeups is that the processor is able to do other work during the 100us it was
> > previously busy-waiting, and thus had to wake up less often.
> 
> As I said in the prior email the udelay()'s don't preclude other types
> of work since you can get preempted.

Yes, you can get preempted, but you'll still spin in the tight loop
counting...

So it does not preclude other task, but then you'll spin
unneccessarily.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
