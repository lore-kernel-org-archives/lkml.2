Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1ACFuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:50:20 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48777 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751150Ab1ACFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:50:19 -0500
Date: Mon, 3 Jan 2011 06:50:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brown <davidb@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking
 assembly volatile
Message-ID: <20110103055015.GA19801@elf.ucw.cz>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-2-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.00.1012201638150.10437@xanadu.home>
 <20110102090019.GC32469@atrey.karlin.mff.cuni.cz>
 <8yazkrjkuo3.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yazkrjkuo3.fsf@huya.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-01-02 10:49:32, David Brown wrote:
> On Sun, Jan 02 2011, Pavel Machek wrote:
> 
> >> > diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
> >> > index 6470f63..155ec10 100644
> >> > --- a/drivers/char/hvc_dcc.c
> >> > +++ b/drivers/char/hvc_dcc.c
> >> > @@ -33,8 +33,7 @@
> >> >  static inline u32 __dcc_getstatus(void)
> >> >  {
> >> >  	u32 __ret;
> >> > -
> >> > -	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
> >> > +	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
> >> >  		: "=r" (__ret) : : "cc");
> >> >  
> >> >  	return __ret;
> >
> > Is volatile needed here? If __dcc_getstatus() return value is
> > discarded, we want assembly discarded, right?
> 
> That's not really the issue being fixed.  Without the volatile, the
> compiler is free to cache and reuse a previously loaded status value.
> It is important that the status be read each time.
> 
> I don't think there is a way of indicating that assembly needs to happen
> for each use, but that it is OK to discard if the value isn't used.
> 'volatile' is a bit overloaded.

Ok, thanks for explanation.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
