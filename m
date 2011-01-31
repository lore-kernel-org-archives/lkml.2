Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1AaWAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:00:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:42926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1AaWAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:00:30 -0500
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE Labs
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
Date: Mon, 31 Jan 2011 23:00:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <201101202202.01089.rjw@suse.com> <4D472B9E.5090000@gmail.com>
In-Reply-To: <4D472B9E.5090000@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101312300.34008.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Jiri Slaby wrote:
> On 01/20/2011 10:02 PM, Rafael J. Wysocki wrote:
> > On Thursday, January 20, 2011, Jiri Slaby wrote:
> >> On 01/06/2011 03:18 PM, Jiri Slaby wrote:
> >>> On 12/14/2010 11:22 PM, Rafael J. Wysocki wrote:
> >>>> On Tuesday, December 14, 2010, Jiri Slaby wrote:
> >>>>> On 12/13/2010 10:10 PM, Rafael J. Wysocki wrote:
> >>>>>> On Monday, December 13, 2010, Jiri Slaby wrote:
> >>>>>>> On 12/05/2010 02:08 PM, Rafael J. Wysocki wrote:
> >>>>>>>> On Sunday, December 05, 2010, Jiri Slaby wrote:
> >>>>>>>>> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
> >>>>>>>>>> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
> >>>>>>>>>
> >>>>>>>>> Hi, this kernel regresses with respect to resume. It doesn't wake up,
> >>>>>>>>> the screen is black with blinking cursor at position [1, 1].
> >>>>>>>>> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
> >>>>>>>>> far.
> >>>>>>>>>
> >>>>>>>>> I'm using pm-suspend, any ideas what to test before I start to find the
> >>>>>>>>> reason on my own?
> >>>>>>>>
> >>>>>>>> Please try the pm_test tests for core, processors and devices, eg.:
> >>>>>>>
> >>>>>>> Hmm, I haven't seen the issues since then. So it had to be some kind of
> >>>>>>> coincidence -- I see the issue occasionally for some time already. Now
> >>>>>>> it triggered twice in a row after I updated the kernel.
> >>>>>>
> >>>>>> Hmm.  What hardware is that?
> >>>>>
> >>>>> What exactly do you want to know about it? It's some specific intel
> >>>>> desktop machine, 3 years old, 2 intel cores, 6G of mem, 2 sata disks in
> >>>>> raid, dvb-t usb receiver (af9015), usb keyboard and mouse.
> >>>>
> >>>> I'm seeing pretty much the same symptoms on quite different hardware, except
> >>>> for one thing: USB keyboard and mouse.
> >>>>
> >>>> Have you checked if writing 0 to /sys/power/pm_async helps?
> >>>
> >>> It's very hard to reproduce (it happens once a week or two), so I can't
> >>> say yet. As it happened yesterday again, going to test it from now on.
> >>
> >> Ok, I haven't seen the issue with 0 in /sys/power/pm_async for two weeks
> >> now (I added it to boot.local). I would say it's related to that...
> > 
> > In that case the next step would be to build the kernel with
> > CONFIG_PM_ADVANCED_DEBUG set and try to switch the async flag for individual
> > devices (it is located is /sys/devices/.../power/ for each device).
> > 
> > For example, I wonder if it is sufficient to unset it for all USB devices.
> 
> It seems to suffice... No hangs still. Should I enable pm_async back
> again to confirm the issue is still present?

Yes, please, it would be good to know for sure.

> Note that I also had had issues with fan which was at full speed after
> resume sometimes (very rarely, like this issue). Full power-cycle was
> needed to cure that. I don't see that now as well.

This most likely was a different issue and I'd expect it to be fixed by
the ACPI patches that went in during the last merge window.

Thanks,
Rafael
