Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1AGCad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:30:33 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47270 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1AGCab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:30:31 -0500
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rjw@sisk.pl
In-Reply-To: <AANLkTin8cntsFpaikpfzPbWL1YFb702rPync240X4axW@mail.gmail.com>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	 <1294280159-2513-13-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
	 <1294337041.4518.87.camel@work-vm>
	 <AANLkTin8cntsFpaikpfzPbWL1YFb702rPync240X4axW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 18:30:20 -0800
Message-ID: <1294367420.4518.171.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 16:58 -0800, Arve Hjønnevåg wrote:
> 2011/1/6 John Stultz <john.stultz@linaro.org>:
> > So otherwise, do you see any reason why android might not be able to
> > adapt this code to replace the android alarm timers?
> >
> 
> The user-space interface does not look appealing, but I don't see any
> reason why the in-kernel interface(s) cannot be shared. Our user-space
> code has a single thread that waits for alarms to trigger, while the
> alarms can be modified from any thread.

So its something like nanosleep(), only other threads can extend or
shorten the sleep time?

Could you explain some of the rational for such an interface, so I can
better understand the need?

>  As far as I can tell, using
> the posix interface would either require a thread per alarm (up to 5)
> or using signals. Both make the user-space code more complicated, and

Yea, it probably would need signals, but I'd have to grok the use case a
little better. And its possible it would complicate the user-space code
some, but on the other hand, it would be using a more standard kernel
interface. The other option is extending the posix interface to try to
better match the need.

> it is not clear if either of them provide a clear hand-off between
> where the kernel needs to block suspend because the alarm has not been
> delivered to user-space and where user-space needs to block suspend
> because it is handling the alarm.

Indeed. I'm still looking into the pm_wake details to see the
limitations there. Some method of inheriting a stay_awake seems to be
needed, but sounds pretty ugly. Alternatively we may need some method or
callback to the kernel to detect that a signal has been handled by
userland (allowing the pm_relax to occur).

Rafael: Any thoughts here?

thanks
-john


