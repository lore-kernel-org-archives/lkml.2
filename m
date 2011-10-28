Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1J1HCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:02:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49047 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1J1HCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:02:32 -0400
Message-ID: <1319785345.23224.75.camel@work-vm>
Subject: Re: [PATCH] time: Improve documentation of timekeeeping_adjust()
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chen Jie <chenj@lemote.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 28 Oct 2011 00:02:25 -0700
In-Reply-To: <20111028060534.GB1957@netboy.at.omicron.at>
References: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
	 <20111028060534.GB1957@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11102807-1780-0000-0000-00000086E770
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 08:05 +0200, Richard Cochran wrote:
> On Thu, Oct 27, 2011 at 06:12:42PM -0700, John Stultz wrote:
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index a5846a8..de8737e 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -802,14 +802,44 @@ static void timekeeping_adjust(s64 offset)
> >  	s64 error, interval = timekeeper.cycle_interval;
> >  	int adj;
> >  
> > +	/*
> > +	 * The point of this is to check if the error is greater then half
> > +	 * an interval.
> > +	 *
> > +	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
> > +	 *
> > +	 * Note we subtract one in the shift, so that error is really error*2.
> > +	 * This "saves" dividing(shifting) intererval twice, but keeps the
> > +	 * (error > interval) comparision as still measuring if error is
> > +	 * larger then half an interval.
> > +	 *
> > +	 * Note: It does not "save" on aggrivation when reading the code.
> 
> ... or on "aggravation" either :)

Sigh. I do need to start using an editor with built in spell checking.
I'm so poor of a speller (and a typist) its really amazing its not
worse.

Thanks for catching that.
-john


