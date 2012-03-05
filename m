Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2CESf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:35:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38101 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab2CESfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:35:25 -0500
Message-ID: <1330972323.2191.74.camel@work-vm>
Subject: Re: WARNING: Adjusting tsc more then 11%
From: John Stultz <john.stultz@linaro.org>
To: Dave Jones <davej@redhat.com>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 05 Mar 2012 10:32:03 -0800
In-Reply-To: <20120305154411.GA29668@redhat.com>
References: <20120305154411.GA29668@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030518-6078-0000-0000-000008BAD716
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 10:44 -0500, Dave Jones wrote:
> John,
> We've had a number of reports the last few weeks triggering
> this warning that you added back in October.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=798600
> https://bugzilla.redhat.com/show_bug.cgi?id=799215
> https://bugzilla.redhat.com/show_bug.cgi?id=799745
> https://bugzilla.redhat.com/show_bug.cgi?id=799872
> 
> any idea what could have changed to start tripping that up ?
> 
> The reports seem to have started around 3.3-rc4.

Huh. No I don't know what would have started causing such a warning. I
had expected that there would be some edge hardware that might trip that
warning, but I'd expect the noise to start there w/ 3.2 after it was
introduced. There's only been spelling & comment changes to the
timekeeping core in the 3.3-rc series.

Looking at the logs, I'm curious if maybe some of the nohz changes have
tweaked us here. If we're hitting longer idle times, it might be
possible the ntp error could accumulate to be larger, and then the
kernel's frequency adjustments might end up trying to adjust for more
then 11%. 

Its also interesting its only popping up on hardware using the TSC.
acpi_pm can only do short idle times, so it wouldn't show up here, but
hpet could do reasonably long idles, so I'd think we'd also see some
similar hpet warnings.

Do you know if this is an occasional thing on any of the affected
hardware, or if it happens after every reboot?

Are any of the reported boxes systems you have access to in order to
reproduce?

thanks
-john


