Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0JGVov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:44:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0JGVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:44:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] ACPI: Read TSC upon resume
Date: Thu, 7 Oct 2010 23:43:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, lenb@kernel.org, stefan.bader@canonical.com,
        brad.figg@canonical.com, apw@canonical.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1286406919-6236-1-git-send-email-snanda@chromium.org> <201010072159.31482.rjw@sisk.pl> <AANLkTimD5Vrjp8tB6crdaOdS-=LYV+JZL0tCLLcruFGu@mail.gmail.com>
In-Reply-To: <AANLkTimD5Vrjp8tB6crdaOdS-=LYV+JZL0tCLLcruFGu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010072343.46433.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 07, 2010, Sameer Nanda wrote:
> On Thu, Oct 7, 2010 at 12:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, October 07, 2010, Sameer Nanda wrote:
> >> (resending as plain text, sorry if you got dupe messages)
> >>
> >> On Wed, Oct 6, 2010 at 7:19 PM, Greg KH <gregkh@suse.de> wrote:
> >> > On Wed, Oct 06, 2010 at 04:15:19PM -0700, Sameer Nanda wrote:
> >> >> Read the TSC upon resuming and print it out. This is useful
> >> >> in helping figure out amount of time spent in the BIOS when
> >> >> resuming from suspend.
> >> >>
> >> >> Change-Id: I1d6a32bd62421becddecd152d561763e5f3e1101
> >> >
> >> > What is this tag for?  I don't think it matches anything the kernel
> >> > community wants, do you?
> >>
> >> Yeah, its not needed.  Let me resubmit the patch without this tag.
> >>
> >> >
> >> > And are you always going to be printing this out?  Why do we want to
> >> > know this every time?
> >>
> >> Yes, every time.  This helps track variance in BIOS resume times
> >> within a single boot.
> >>
> >> >
> >> >> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> >> >> ---
> >> >>  drivers/acpi/sleep.c |    4 ++++
> >> >>  1 files changed, 4 insertions(+), 0 deletions(-)
> >> >>
> >> >> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> >> >> index c0fed2e..f0588fa 100644
> >> >> --- a/drivers/acpi/sleep.c
> >> >> +++ b/drivers/acpi/sleep.c
> >> >> @@ -214,6 +214,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
> >> >>       acpi_status status = AE_OK;
> >> >>       unsigned long flags = 0;
> >> >>       u32 acpi_state = acpi_target_sleep_state;
> >> >> +     u64 tsc;
> >> >>
> >> >>       ACPI_FLUSH_CPU_CACHE();
> >> >>
> >> >> @@ -235,6 +236,9 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
> >> >>
> >> >>       case ACPI_STATE_S3:
> >> >>               do_suspend_lowlevel();
> >> >> +             rdtscll(tsc);
> >> >> +             printk(KERN_INFO "TSC at resume: %llu\n",
> >> >> +                             (unsigned long long)tsc);
> >> >
> >> > How long does this take, will it slow down resume?
> >>
> >> The impact is ~10us (as measured on an Intel Atom N455 @ 1.66Ghz).
> >> Given that resume time is currently of the order of 1sec, its in the
> >> noise range.
> >
> > Do I think correctly that it assumes the TSC will be updated in the sleep state?
> 
> No, it actually banks on TSC not being updated while the system is in S3 state.
> Theory here being that upon resuming from S3, the CPU gets reset and so TSC
> starts counting up from 0.  Therefore, reading the TSC value in the kernel upon
> resuming gives the number of cycles spent in the BIOS in resume path.

Ah that.  OK, that's more clear now.

Thanks,
Rafael
