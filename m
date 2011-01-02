Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1ABJAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:00:22 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51081 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895Ab1ABJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:00:20 -0500
Date: Sun, 2 Jan 2011 10:00:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking
	assembly volatile
Message-ID: <20110102090019.GC32469@atrey.karlin.mff.cuni.cz>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org> <1292875718-7980-1-git-send-email-sboyd@codeaurora.org> <1292875718-7980-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1012201638150.10437@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012201638150.10437@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
> > index 6470f63..155ec10 100644
> > --- a/drivers/char/hvc_dcc.c
> > +++ b/drivers/char/hvc_dcc.c
> > @@ -33,8 +33,7 @@
> >  static inline u32 __dcc_getstatus(void)
> >  {
> >  	u32 __ret;
> > -
> > -	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
> > +	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
> >  		: "=r" (__ret) : : "cc");
> >  
> >  	return __ret;

Is volatile needed here? If __dcc_getstatus() return value is
discarded, we want assembly discarded, right?


> > @@ -58,7 +57,7 @@ static inline char __dcc_getchar(void)
> >  {
> >  	char __c;
> >  
> > -	asm("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
> > +	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
> >  		: "=r" (__c));
> >  
> >  	return __c;

Same here?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
