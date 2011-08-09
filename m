Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1HIFjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 01:39:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:2316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1HIFjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 01:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,342,1309762800"; 
   d="scan'208";a="35876969"
Subject: Re: [linux-pm] [PATCH v3] PM: add statistics debugfs file for
 suspend to ram
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJ0PZbQ4Bk7Up9texX2hU8NP583da7UP9Hk3GRHE6-VKsg69kA@mail.gmail.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B8057C306@shsmsx502.ccr.corp.intel.com>
	 <CAJ0PZbQ4Bk7Up9texX2hU8NP583da7UP9Hk3GRHE6-VKsg69kA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 09 Aug 2011 13:38:12 +0800
Message-ID: <1312868292.1743.15.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 13:49 +0900, MyungJoo Ham wrote:
> On Tue, Aug 9, 2011 at 11:27 AM, Liu, ShuoX <shuox.liu@intel.com> wrote:
> > From: ShuoX Liu <shuox.liu@intel.com>
> >
> > Record S3 failure time about each reason and the latest two failed
> > devices' names in S3 progress.
> > We can check it through 'suspend_stats' entry in debugfs.
> >
> > The motivation of the patch:
> >
> > We are enabling power features on Medfield. Comparing with PC/notebook,
> > a mobile enters/exits suspend-2-ram (we call it s3 on Medfield) far
> > more frequently. If it can't enter suspend-2-ram in time, the power
> > might be used up soon.
> >
> > We often find sometimes, a device suspend fails. Then, system retries
> > s3 over and over again. As display is off, testers and developers
> > don't know what happens.
> >
> > Some testers and developers complain they don't know if system
> > tries suspend-2-ram, and what device fails to suspend. They need
> > such info for a quick check. The patch adds suspend_stats under
> > debugfs for users to check suspend to RAM statistics quickly.
> >
> > If not using this patch, we have other methods to get info about
> > what device fails. One is to turn on  CONFIG_PM_DEBUG, but users
> > would get too much info and testers need recompile the system.
> >
> > In addition, dynamic debug is another good tool to dump debug info.
> > But it still doesn't match our utilization scenario closely.
> > 1) user need write a user space parser to process the syslog output;
> > 2) Our testing scenario is we leave the mobile for at least hours.
> >   Then, check its status. No serial console available during the
> >   testing. One is because console would be suspended, and the other
> >   is serial console connecting with spi or HSU devices would consume
> >   power. These devices are powered off at suspend-2-ram.
> >
> > Thank Greg and Rafael for their great comments.
> >
> > Change Log:
> >  V3: Change some programming styles.
> >  V2:
> >        1) Change the sysfs entry to debugfs.
> >        2) Add some explanation in document file.
> >
> > Contribution:
> >        yanmin_zhang@linux.intel.com
> >
> > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > ---
> >  Documentation/power/basic-pm-debugging.txt |   19 +++++++++
> >  drivers/base/power/main.c                  |   35 ++++++++++++++--
> >  include/linux/suspend.h                    |   16 +++++++
> >  kernel/power/main.c                        |   59 ++++++++++++++++++++++++++++
> >  kernel/power/suspend.c                     |   15 ++++++-
> >  5 files changed, 136 insertions(+), 8 deletions(-)
> >
> 
> This patch looks very helpful. Great! :)
> 
> Anyway, how about including the error value induced by the device
> along with the device name?
> For example,
> 
> failed_devs:
>          last_failed: alarm -5
>                       adc -10
> 
> or
> 
> failed_devs:
>          last_failed: alarm
>                       adc
>          last_errorno: -5
>                       -10
> 

> Or, even, we may consider including the failed step:
> failed_devs:
>          last_failed: alarm
>                       adc
>          last_errorno: -5
>                       -10
>          last_step: suspend
>                       suspend_noirq
> 
It's a good idea! We would change it to output like above format.

Thanks MyunJoo.


