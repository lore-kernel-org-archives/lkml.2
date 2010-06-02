Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0FBJHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:07:44 -0400
Received: from www.tglx.de ([62.245.132.106]:48502 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0FBJHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:07:42 -0400
Date: Wed, 2 Jun 2010 11:07:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006021059150.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005302202.39511.rjw@sisk.pl> <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com> <201005312347.24251.rjw@sisk.pl> <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
 <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain> <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com> <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain> <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-305410675-1275469630=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-305410675-1275469630=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 2 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/2 Thomas Gleixner <tglx@linutronix.de>:
> > On Tue, 1 Jun 2010, Arve Hjønnevåg wrote:
> >>
> >> Because suspend itself causes you to not be idle you cannot abort
> >> suspend just because you are not idle anymore.
> >
> > You still are addicted to the current suspend mechanism. :)
> >
> 
> No I want you to stop confusing low power idle modes with suspend. I
> know how to enter low power modes from idle if that low power mode is
> not too disruptive.

What prevents us from going into a disruptive mode from idle ? I don't
see a reason - except crappy ACPI stuff, which I'm happy to ignore.

> > If I understood you correctly then you can shutdown the CPU in idle
> > completelty already, but that's not enough due to:
> >
> >    1) crappy applications keeping the cpu away from idle
> >    2) timers firing
> >
> > Would solving those two issues be sufficient for you or am I missing
> > something ?
> 
> Solving those two is enough for current android phones, but it may not
> be enough for other android devices.

In which way ? May not be enough is a pretty vague statement.

> 1 is not solvable (meaning we cannot fix all apps),

We can mitigate it with cgroups and confine crap there, i.e. force
idle them.

> and 2 is difficult to fix since the periodic
> work is useful while the device is actually in use. One possible way
> to solve 2 is to allow timers on a not-idle clock.

That's what I had in mind.

> Unrelated to Android, I also want to use opportunistic suspend on my
> desktop.

I expect that intel/amd fixing their stuff is going to happen way
before we sprinkled suspend blockers over a full featured desktop
distro.

Thanks,

	tglx
--8323328-305410675-1275469630=:2933--
