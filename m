Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab1CBJmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:42:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49843 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756072Ab1CBJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:42:07 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/9pTBVcCv9/YpyACZyLwJuw8e+Ek7JXwMFKl89me
	y2e12uWI7BU6AT
Date: Wed, 2 Mar 2011 10:41:59 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richard.cochran@omicron.at>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'John Stultz'" <john.stultz@linaro.org>,
        "'Ingo Molnar'" <mingo@elte.hu>,
        "'Peter Zijlstra'" <peterz@infradead.org>
Subject: Re: [patch 00/28]  Rework of the PTP support series core code
Message-ID: <20110302094159.GA4903@siel.b>
Mail-Followup-To: Richard Cochran <richard.cochran@omicron.at>,
	'Thomas Gleixner' <tglx@linutronix.de>,
	'LKML' <linux-kernel@vger.kernel.org>,
	'John Stultz' <john.stultz@linaro.org>,
	'Ingo Molnar' <mingo@elte.hu>,
	'Peter Zijlstra' <peterz@infradead.org>
References: <20110201134320.688829863@linutronix.de>
 <20110301153809.GA2934@siel.b>
 <95DC1AA8EC908B48939B72CF375AA5E3011C94941E@alice.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95DC1AA8EC908B48939B72CF375AA5E3011C94941E@alice.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 07:50:55PM +0100, Richard Cochran wrote:
> >> Richard, can you please run that through your testing ? The PTP
> >> drivers apply on top of that.
> >
> >i am a bit puzzled how a software ptp clock would fit into this
> >framework. for some avb use-cases we could get away with a ptp clock
> >thats only accurate to a few 100us.
> >
> >from a few quick glances it seems, that if userspace is able to create a
> >ptp clock driven by normal timers and the kernel allows for timestamping
> >packets using that clock, a modified ptpd could do the trick.
> >
> >i am not sure, how much of this should be happening in userspace though.
> 
> The point of the PHC patch set is to support special hardware clocks.
> After much discussion (see the links in the V12 patch set) we have come
> up with an API that will work both with software only (ie normal system
> time) as well as with hardware clocks.
> 
> The application just uses: clockid_t id = CLOCK_REALTIME
> if it wants to use software time stamping with the normal system clock.

this assumes, that the ptp master clock is actually suitable to be
CLOCK_REALTIME. i am not sure if this assumption holds true, when the
master clock is an audio clock, of some cheap soundcard.

in that case, we need to relate the audio clock to CLOCK_REALTIME.
thats surely possible, but we end up with 2 cascaded clock servos.

additionally userspace must then manage to get the master clocks
relations from the ptpd to the app that plays out the audio.

if i was using a h/w clock, i could just make the audio playing app
query the h/w ptp clock using the right clockid.

so it looks like i would end up with a different api on the audio side.

> 
> I have some patches for the ptpd that show how the API works, and I
> will be reposting those to the ptpd.sf.net in the next few days.
> 
> HTH,
> Richard
> 

-- 
torben Hohn
