Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0LBPix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:38:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58309 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751517Ab0LBPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:38:52 -0500
Date: Thu, 2 Dec 2010 10:38:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors
 unnecessarily
In-Reply-To: <201012020050.31171.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012021038040.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Rafael J. Wysocki wrote:

> OK, so please let me know what you think of the appended patch (on top of the
> previous one).
> 
> Thanks,
> Rafael
> Index: linux-2.6/include/linux/suspend.h
> ===================================================================
> --- linux-2.6.orig/include/linux/suspend.h
> +++ linux-2.6/include/linux/suspend.h
> @@ -292,7 +292,7 @@ extern int unregister_pm_notifier(struct
>  /* drivers/base/power/wakeup.c */
>  extern bool events_check_enabled;
>  
> -extern bool pm_check_wakeup_events(void);
> +extern bool pm_wakeup_pending(void);
>  extern bool pm_get_wakeup_count(unsigned int *count);
>  extern bool pm_save_wakeup_count(unsigned int count);
>  #else /* !CONFIG_PM_SLEEP */
> @@ -309,7 +309,7 @@ static inline int unregister_pm_notifier
>  
>  #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
>  
> -static inline bool pm_check_wakeup_events(void) { return true; }
> +static inline bool pm_wakeup_pending(void) { return true; }

Shouldn't this return false?

Alan Stern

