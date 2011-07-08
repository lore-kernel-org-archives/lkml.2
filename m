Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1GHRmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:42:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1GHRmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:42:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 5/7] PM: PM notifier error injection
Date: Fri, 8 Jul 2011 19:43:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com> <201107072314.59052.rjw@sisk.pl> <CAC5umyifMvVTG29JyvBtc_YThorK=AZHZypheUvbtvmShnbTog@mail.gmail.com>
In-Reply-To: <CAC5umyifMvVTG29JyvBtc_YThorK=AZHZypheUvbtvmShnbTog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107081943.20482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 08, 2011, Akinobu Mita wrote:
> >> --- a/kernel/power/main.c
> >> +++ b/kernel/power/main.c
> >> @@ -42,6 +42,36 @@ int pm_notifier_call_chain(unsigned long val)
> >>       return notifier_to_errno(ret);
> >>  }
> >>
> >> +#ifdef CONFIG_PM_NOTIFIER_ERROR_INJECTION
> >> +
> >> +static struct err_inject_notifier_block err_inject_pm_notifier = {
> >> +     .actions = {
> >> +             { ERR_INJECT_NOTIFIER_ACTION(PM_HIBERNATION_PREPARE) },
> >> +             { ERR_INJECT_NOTIFIER_ACTION(PM_SUSPEND_PREPARE) },
> >> +             { ERR_INJECT_NOTIFIER_ACTION(PM_RESTORE_PREPARE) },
> >> +             {}
> >
> > Why have you omitted the PM_POST_* actions?
> 
> Because the callbacks of PM_POST_* are not supposed to fail (i.e.
> the return value of pm_notifier_call() is ignored).

OK, fair enough.

> >> --- a/lib/Kconfig.debug
> >> +++ b/lib/Kconfig.debug
> >> @@ -1043,6 +1043,14 @@ config CPU_NOTIFIER_ERROR_INJECTION
> >>         # echo 0 > /sys/devices/system/cpu/cpu1/online
> >>         bash: echo: write error: Operation not permitted
> >>
> >> +config PM_NOTIFIER_ERROR_INJECTION
> >> +     bool "PM notifier error injection"
> >> +     depends on PM_DEBUG && NOTIFIER_ERROR_INJECTION
> >> +     help
> >> +       This option provides the ability to inject artifical errors to
> >> +       PM notifier chain callbacks.  It is controlled through debugfs
> >> +       interface under /sys/kernel/debug/pm-notifier-error-inject/
> >
> > I'm not sure the help is necessary.  I think it should be selected
> > automatically if both PM_DEBUG and NOTIFIER_ERROR_INJECTION are set.
> 
> OK, I'll try to tweak the option to be better.

Thanks!

Rafael
