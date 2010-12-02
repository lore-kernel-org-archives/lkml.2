Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0LBTnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:43:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49280 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab0LBTnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:43:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Thu, 2 Dec 2010 20:42:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>
References: <Pine.LNX.4.44L0.1012021038040.1921-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012021038040.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012022042.31954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010, Alan Stern wrote:
> On Thu, 2 Dec 2010, Rafael J. Wysocki wrote:
> 
> > OK, so please let me know what you think of the appended patch (on top of the
> > previous one).
> > 
> > Thanks,
> > Rafael
> > Index: linux-2.6/include/linux/suspend.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/suspend.h
> > +++ linux-2.6/include/linux/suspend.h
> > @@ -292,7 +292,7 @@ extern int unregister_pm_notifier(struct
> >  /* drivers/base/power/wakeup.c */
> >  extern bool events_check_enabled;
> >  
> > -extern bool pm_check_wakeup_events(void);
> > +extern bool pm_wakeup_pending(void);
> >  extern bool pm_get_wakeup_count(unsigned int *count);
> >  extern bool pm_save_wakeup_count(unsigned int count);
> >  #else /* !CONFIG_PM_SLEEP */
> > @@ -309,7 +309,7 @@ static inline int unregister_pm_notifier
> >  
> >  #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
> >  
> > -static inline bool pm_check_wakeup_events(void) { return true; }
> > +static inline bool pm_wakeup_pending(void) { return true; }
> 
> Shouldn't this return false?

Yes, it should, thanks!

Rafael
