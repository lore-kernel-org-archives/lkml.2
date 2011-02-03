Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1BCW1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:27:46 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51831 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1BCW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:27:45 -0500
Subject: Re: [PATCH 0/4] RTC regression fixups
From: john stultz <johnstul@us.ibm.com>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1296769047.3336.332.camel@work-vm>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
	 <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com>
	 <1296760576.3336.324.camel@work-vm>
	 <AANLkTikgTNVkxeb+4HQonce-Y=z7EpxXn_SuwVj=EdE2@mail.gmail.com>
	 <1296769047.3336.332.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 14:27:37 -0800
Message-ID: <1296772057.3336.369.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 13:37 -0800, John Stultz wrote:
> On Thu, 2011-02-03 at 18:31 -0200, Marcelo Roberto Jimenez wrote:
> > 1 - Should the callback be removed or should it be kept and called in
> > the else part?
> 
> So, we probably should change the check to set_alarm or some other flag
> to check if the hardware supports irqs, then remove the driver
> read_alarm() function.

Ok. Just got a first pass on that done. Check out my dev/rtc-cleanups branch here:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/rtc-cleanups

So after cleaning up irq_set_state, irq_set_freq, update_irq_enable, and
read_alarm, we're looking at a nice reduction of code:

 54 files changed, 4 insertions(+), 2127 deletions(-)

Now, my one hesitation is for read_alarm. I'm not totally sure we won't
want to access that functionality from the generic layer at some point.
And I would hate to kill it and then realize we need it afterwards.

But it does nicely clean things up, so maybe we can decide on this by
the time 2.6.39 opens up.

Alessandro: Any thoughts?

thanks
-john


