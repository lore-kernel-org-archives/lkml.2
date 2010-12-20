Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab0LTU46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:56:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab0LTU45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:56:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [Bug #20232] kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
Date: Mon, 20 Dec 2010 21:56:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera> <1292841313.2708.137.camel@laptop> <4D0F8890.2070307@kernel.org>
In-Reply-To: <4D0F8890.2070307@kernel.org>
MIME-Version: 1.0
Message-Id: <201012202156.00621.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 20, 2010, Tejun Heo wrote:
> Hello,
> 
> On 12/20/2010 11:35 AM, Peter Zijlstra wrote:
> > On Sun, 2010-12-19 at 13:50 +0100, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.35 and 2.6.36.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> >> be listed and let the tracking team know (either way).
> >>
> >>
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20232
> >> Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
> >> Submitter	: Ozan Caglayan <ozan@pardus.org.tr>
> >> Date		: 2010-10-13 06:13 (68 days old)
> > 
> > I'd be thinking that kworker going wonky is something for Tejun to have
> > a look at.. Anyway, is it still relevant for current kernels?
> 
> It looks like the work is scheduled in loop, so the kworker acting out
> seems to be the symptom of the problem not the cause.  Looks like
> Rafael already has a proper fix on mind, so...

Rather, something that _might_ work.

I'm quite confident that this is a BIOS issue.  Apparently, the BIOS tells us
we can control PCI Express hotplug, but then it tries to do that itself via
ACPI at the same time and that leads to a GPE storm.  We may try to poke the
BIOS a bit differently than we do right now, but whether or not it helps is
to be seen.

Also, we can try to handle both ACPI-based and native PCIe hotplug
simultaneously at the same port, but that's going to be tricky.

We still can use DMI-based blacklisting as the last resort.

Thanks,
Rafael
