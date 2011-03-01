Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1CAPiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:38:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45284 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756491Ab1CAPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:38:20 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/KrqFGnKLKOhp1Akn0UXPPqxowRivDZ1BzLqzNxl
	3Eb4/qZmeFLpUc
Date: Tue, 1 Mar 2011 16:38:09 +0100
From: torbenh <torbenh@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/28]  Rework of the PTP support series core code
Message-ID: <20110301153809.GA2934@siel.b>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Richard Cochran <richard.cochran@omicron.at>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <20110201134320.688829863@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134320.688829863@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:50:55PM -0000, Thomas Gleixner wrote:
> This is a rework of Richards PTP support series core code. The PTP
> driver patches are unchanged and not included in this series.
> 
> The reason for this rework is that I got scared when reviewing:
>  [PATCH V10 09/15] posix clocks: cleanup the CLOCK_DISPTACH macro
> 
> The patch is really too large and the risk of wreckage too high. So
> instead of whipping Richard through another round I reworked the
> series in the following way:
> 
> 1) Split the CLOCK_DISPATCH cleanup in fine grained steps.
>    
>    That allowed further cleanups and got rid of 200 lines of code and
>    made a lot of functions static.
>    
>    It also fixes subtle changes to the error return codes which happened
>    in the large all in one overhaul (EINVAL vs. ENOTSUP).
>    
> 2) Move the patches which add new functionality after the cleanup.
> 
>    It does not make sense to add new functionality into the old scheme
>    first and then clean it up.
> 
> Richard, can you please run that through your testing ? The PTP
> drivers apply on top of that.

i am a bit puzzled how a software ptp clock would fit into this
framework. for some avb use-cases we could get away with a ptp clock
thats only accurate to a few 100us.

from a few quick glances it seems, that if userspace is able to create a
ptp clock driven by normal timers and the kernel allows for timestamping 
packets using that clock, a modified ptpd could do the trick.

i am not sure, how much of this should be happening in userspace though.


-- 
torben Hohn
