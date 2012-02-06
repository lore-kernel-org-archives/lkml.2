Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2BFLxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:53:21 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57762 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab2BFLxT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:53:19 -0500
MIME-Version: 1.0
In-Reply-To: <87pqdv4oo3.fsf@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<87pqdv4oo3.fsf@ti.com>
Date: Mon, 6 Feb 2012 17:23:18 +0530
Message-ID: <CAC83ZvJndyGv6KAuzn1GLYMMNH1cC-u3=sdHxqO+q-xtaFbnVA@mail.gmail.com>
Subject: Re: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, tony@atomide.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Sat, Feb 4, 2012 at 2:31 AM, Kevin Hilman <khilman@ti.com> wrote:
>
> Hi Tarun,
>
> Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:
>
> > The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
> >   Linus Torvalds (1):
> >         Linux 3.3-rc2
> >
> > are available in the git repository at:
> > http://gitorious.org/~tarunkanti/omap-sw-develoment/tarunkantis-linux-omap-dev
> > Branch: for_3.4/gpio_cleanup_fixes_v9
> >
> > This series is continuation of cleanup of OMAP GPIO driver and fixes.
> > The cleanup include getting rid of cpu_is_* checks wherever possible,
> > use of gpio_bank list instead of static array, use of unique platform
> > specific value associated data member to OMAP platforms to avoid
> > cpu_is_* checks. The series also include PM runtime support.
>
> This version is looking pretty good, and I'm almost ready to queue it up
> for Grant.
>
> However, one more minor nit.  Please fix up the compile warnings when
> built without CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME.
>
> The definitons of the dev_pm_ops callbacks need to be conditional when
> using the SET_*_PM_OPS() macros, otherwise you get these warnings:

I have updated the branch with the required changes.
--
Tarun
>
>
>
>  CC      drivers/gpio/gpio-omap.o
> /work/kernel/omap/pm/drivers/gpio/gpio-omap.c:1142:12: warning: 'omap_gpio_suspend' defined but not used [-Wunused-function]
> /work/kernel/omap/pm/drivers/gpio/gpio-omap.c:1167:12: warning: 'omap_gpio_resume' defined but not used [-Wunused-function]
> /work/kernel/omap/pm/drivers/gpio/gpio-omap.c:1191:12: warning: 'omap_gpio_runtime_suspend' defined but not used [-Wunused-function]
> /work/kernel/omap/pm/drivers/gpio/gpio-omap.c:1237:12: warning: 'omap_gpio_runtime_resume' defined but not used [-Wunused-function]
>
>
> Thanks,
>
> Kevin
