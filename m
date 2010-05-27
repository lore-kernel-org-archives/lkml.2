Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0E0DP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:15:58 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60512 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932603Ab0E0DP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:15:57 -0400
Date: Thu, 27 May 2010 08:44:44 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Virupax SADASHIVPETIMATH 
	<virupax.sadashivpetimath@stericsson.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] rtc: AB8500 RTC driver
Message-ID: <20100527031443.GA6926@bnru02.bnr.st.com>
References: <1274453796-9141-1-git-send-email-rabin.vincent@stericsson.com>
 <20100525135159.166d91c6.akpm@linux-foundation.org>
 <20100526121150.GA17197@bnru02.bnr.st.com>
 <20100526120904.00fe134c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100526120904.00fe134c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 21:09:04 +0200, Andrew Morton wrote:
> > --- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-rtc-driver-update
> > +++ a/drivers/rtc/rtc-ab8500.c
> > @@ -46,16 +46,25 @@
> >  #define COUNTS_PER_SEC			(0xF000 / 60)
> >  #define AB8500_RTC_EPOCH		2000
> >  
> > +static const unsigned long ab8500_rtc_time_regs[] = {
> > +	AB8500_RTC_WATCH_TMIN_HI_REG, AB8500_RTC_WATCH_TMIN_MID_REG,
> > +	AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
> > +	AB8500_RTC_WATCH_TSECMID_REG
> > +};
> > +
> > +static const unsigned long ab8500_rtc_alarm_regs[] = {
> > +	AB8500_RTC_ALRM_MIN_HI_REG, AB8500_RTC_ALRM_MIN_MID_REG,
> > +	AB8500_RTC_ALRM_MIN_LOW_REG
> > +};
> 
> Well, it wasn't necessary to move these into file-global scope.  It
> would be nicer to leave them in function scope, really.  I was just
> pointing out that the `static' was missing, although unnecessary due to
> compiler magic.

I know, but we moved them out to reduce code duplication because these
lists were used in multiple functions and were copy/pasted in them.

Rabin
