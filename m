Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1ADTOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:14:22 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58624 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1ADTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:14:21 -0500
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
In-Reply-To: <20110104084023.GB4563@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
	 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
	 <1294087466.2571.89.camel@work-vm>
	 <20110104084023.GB4563@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 11:14:14 -0800
Message-ID: <1294168454.2694.9.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 09:40 +0100, Richard Cochran wrote:
> On Mon, Jan 03, 2011 at 12:44:26PM -0800, John Stultz wrote:
> > Richard: Maybe this is a good thing to think about for clock_adjtime? If
> > we are adding a new syscall, maybe we should make sure we clean up some
> > of the old syscalls issues? It does add a good bit of complexity, as the
> > idea of clock_adjtime being a multiplexing adjtimex was nice and simple.
> > We'd also have to review the mode usage to see if multi-mode adjustments
> > in a single call are all that common or not.
> 
> So, is the NTP source code the documentation of the kernel interface?

Yea. adjtimex is a combination of ntp_adjtime and the older adjtime
interfaces. So its not identical to David Mill's design, but it is
compatible.  In fact, it wasn't until somewhat recently that it picked
up the ntpv4 changes and MOD/ADJ_NANO.

By the way, I'm not saying we should switch from using mode flags to
mode numbers for the new interface as I'm not sure if it would confuse
users moving to it (being very similar, but slightly different can be
worse then being totally different). But I figure it warrants some
consideration. We do still have 4 unused bits in the modes flags after
your patch, so this may be a premature worry.

thanks
-john




