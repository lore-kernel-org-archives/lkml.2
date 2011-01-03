Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1ACUod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:44:33 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57658 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1ACUoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:44:32 -0500
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
From: John Stultz <john.stultz@linaro.org>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
In-Reply-To: <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
	 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 12:44:26 -0800
Message-ID: <1294087466.2571.89.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 05:47 +0900, Kuwahara,T. wrote:
> On Tue, Dec 28, 2010 at 8:40 AM, John Stultz <john.stultz@linaro.org> wrote:
> > From: Richard Cochran <richardcochran@gmail.com>
> >
> > This patch adds a new mode bit into the timex structure. When set, the
> > bit instructs the kernel to add the given time value to the current time.
> 
> I came up with this simple solution: "Just use ADJ_OFFSET as usual,
> but don't forget to disable the kernel PLL."

Again, this seems to be trying to add new functionality into a corner
case of a existing mode.

I don't like this because it makes testing and validating that the code
is correct for its uses difficult. Especially given that a number of
combinations of modes might be set at once. What happens to freq
adjustments done at the same time as an ADJ_OFFSET - STA_PLL?

Personally, I see the adjtimex call as too flexible, as I'd prefer to
have the modes be exclusive (adjusting one thing per call). As it is
now, the kernel doesn't throw out enough invalid to invalid-ish cases.
ie: MOD_NANO|MOD_MICRO: totally cool! We should fix these and make the
input checking more strict, but in my mind moving to mode-numbers rather
then mode-flags would be much nicer (and more extendable).

Richard: Maybe this is a good thing to think about for clock_adjtime? If
we are adding a new syscall, maybe we should make sure we clean up some
of the old syscalls issues? It does add a good bit of complexity, as the
idea of clock_adjtime being a multiplexing adjtimex was nice and simple.
We'd also have to review the mode usage to see if multi-mode adjustments
in a single call are all that common or not.

Kuwahara: Maybe could you maybe better explain your passion against
using a new mode-flag for this new functionality? You seem dead set
against it, but have not expressed your rational well.

thanks
-john

