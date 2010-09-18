Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0IRGPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 02:15:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0IRGPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 02:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ucvbWGy0ucAr3BUpHNV3maE4N/BRbbsaZjeVVrXlq75AVM0iEf3tUqFJ2Ezn8bheVu
         Wc6qnzy42zDheves+MFy2X42lnsPWe1DwTC8DI2v1tz4365h/M+yTmPGzKHoH2hoBoII
         SU2O6VJs8G4wHLISRaYrOH6GVXBQsJogSUJyg=
Date: Sat, 18 Sep 2010 08:15:28 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Posix CLOCK_RTC interface proof of concept
Message-ID: <20100918061528.GA3249@riccoc20.at.omicron.at>
References: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
 <alpine.LFD.2.00.1009171154430.2416@localhost6.localdomain6>
 <1284748958.2451.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284748958.2451.68.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:42:38AM -0700, john stultz wrote:
> On Fri, 2010-09-17 at 12:59 +0200, Thomas Gleixner wrote:
> > That's basically a copy of enqueue_hrtimer(). Can't we use
> > k_itimer.it.real for this and reuse the related functions in
> > hrtimer.c? Not sure if it's worth the trouble though.
> 
> Yes, there's also a similar duplication in drivers/char/mmtimer.c and
> Richard Cochran commented on the same (although I'm not sure if he ended
> up using the hrtimer for his similar PTP code).

After taking a look at the hrtimer code, I decided to remove the timer
implementation from the patch set. I do have the userland interface to
timer_create/settime in place, but no clock drivers implement it yet.
 
> I was hoping to find something I could re-use in the hrtimer code, but
> it seemed a little tightly linked to the fixed CLOCK_MONOTONIC/REALTIME
> bases.

That was my impression, too. It looks like hrtimers are hard-coded to
the clock event device via a global per-cpu variable. Would it be
possible to decouple this for multiple, different clock event devices?

Thanks,
Richard
