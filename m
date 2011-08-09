Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1HIUBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:01:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1HIUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:01:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yanmin_zhang@linux.intel.com
Subject: Re: [linux-pm] [PATCH v3] PM: add statistics debugfs file for suspend to ram
Date: Tue, 9 Aug 2011 22:02:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B8057C306@shsmsx502.ccr.corp.intel.com> <CAJ0PZbQ4Bk7Up9texX2hU8NP583da7UP9Hk3GRHE6-VKsg69kA@mail.gmail.com> <1312868292.1743.15.camel@ymzhang>
In-Reply-To: <1312868292.1743.15.camel@ymzhang>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108092202.30644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 09, 2011, Yanmin Zhang wrote:
> On Tue, 2011-08-09 at 13:49 +0900, MyungJoo Ham wrote:
> > On Tue, Aug 9, 2011 at 11:27 AM, Liu, ShuoX <shuox.liu@intel.com> wrote:
> > > From: ShuoX Liu <shuox.liu@intel.com>
> > >
> > > Record S3 failure time about each reason and the latest two failed
> > > devices' names in S3 progress.
> > > We can check it through 'suspend_stats' entry in debugfs.
> > >
> > > The motivation of the patch:
> > >
> > > We are enabling power features on Medfield. Comparing with PC/notebook,
> > > a mobile enters/exits suspend-2-ram (we call it s3 on Medfield) far
> > > more frequently. If it can't enter suspend-2-ram in time, the power
> > > might be used up soon.
> > >
> > > We often find sometimes, a device suspend fails. Then, system retries
> > > s3 over and over again. As display is off, testers and developers
> > > don't know what happens.
> > >
> > > Some testers and developers complain they don't know if system
> > > tries suspend-2-ram, and what device fails to suspend. They need
> > > such info for a quick check. The patch adds suspend_stats under
> > > debugfs for users to check suspend to RAM statistics quickly.
> > >
> > > If not using this patch, we have other methods to get info about
> > > what device fails. One is to turn on  CONFIG_PM_DEBUG, but users
> > > would get too much info and testers need recompile the system.
> > >
> > > In addition, dynamic debug is another good tool to dump debug info.
> > > But it still doesn't match our utilization scenario closely.
> > > 1) user need write a user space parser to process the syslog output;
> > > 2) Our testing scenario is we leave the mobile for at least hours.
> > >   Then, check its status. No serial console available during the
> > >   testing. One is because console would be suspended, and the other
> > >   is serial console connecting with spi or HSU devices would consume
> > >   power. These devices are powered off at suspend-2-ram.
> > >
> > > Thank Greg and Rafael for their great comments.
> > >
> > > Change Log:
> > >  V3: Change some programming styles.
> > >  V2:
> > >        1) Change the sysfs entry to debugfs.
> > >        2) Add some explanation in document file.
> > >
> > > Contribution:
> > >        yanmin_zhang@linux.intel.com
> > >
> > > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > > ---
> > >  Documentation/power/basic-pm-debugging.txt |   19 +++++++++
> > >  drivers/base/power/main.c                  |   35 ++++++++++++++--
> > >  include/linux/suspend.h                    |   16 +++++++
> > >  kernel/power/main.c                        |   59 ++++++++++++++++++++++++++++
> > >  kernel/power/suspend.c                     |   15 ++++++-
> > >  5 files changed, 136 insertions(+), 8 deletions(-)
> > >
> > 
> > This patch looks very helpful. Great! :)
> > 
> > Anyway, how about including the error value induced by the device
> > along with the device name?
> > For example,
> > 
> > failed_devs:
> >          last_failed: alarm -5
> >                       adc -10
> > 
> > or
> > 
> > failed_devs:
> >          last_failed: alarm
> >                       adc
> >          last_errorno: -5
> >                       -10
> > 
> 
> > Or, even, we may consider including the failed step:
> > failed_devs:
> >          last_failed: alarm
> >                       adc
> >          last_errorno: -5
> >                       -10
> >          last_step: suspend
> >                       suspend_noirq
> > 
> It's a good idea! We would change it to output like above format.

OK, I'm expecting a new version of the patch.

Thanks,
Rafael
