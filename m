Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab0KLXxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:53:00 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59830 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab0KLXw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:52:59 -0500
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
In-Reply-To: <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
	 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
	 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
	 <1289605221.3292.53.camel@localhost.localdomain>
	 <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 15:52:39 -0800
Message-ID: <1289605959.3292.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:48 -0500, Andrew Lutomirski wrote:
> On Fri, Nov 12, 2010 at 6:40 PM, john stultz <johnstul@us.ibm.com> wrote:
> > On Fri, 2010-11-12 at 16:52 -0500, Andrew Lutomirski wrote:
> >
> >> if ( wd_elapsed < cs_elapsed and ( (cs_elapsed - wd_elapsed) %
> >> wd_wrapping_time ) < (something fairly small) )
> >>   bail;  // The watchdog most likely wrapped.
> >
> > Huh. The modulo bit may need tweaking as its not immediately clear its
> > right. Maybe the following is clearer?:
> >
> > if ((cs_elapsed > wd_wrapping_time)
> >        && (abs((cs_elapsed % wd_wrapping_time)-wd_elapsed) < MAX_DELTA)
> >        // should be ok.
> 
> I think this is wrong if wd_elapsed is large (which could happen if
> the real wd time is something like (2 * wd_wrapping_time -
> MAX_DELTA/4)).

But wd_elapsed can never be larger then wd_wrapping_time, right?

Or am I still missing something?

thanks
-john


