Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1BNSFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:05:16 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51604 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1BNSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:05:12 -0500
Date: Mon, 14 Feb 2011 23:33:54 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, jacob.jun.pan@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>,
        Wysocki Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [PATCH 1/1, v6] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110214180354.GA17976@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1297213541-18156-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <20110210030442.GG16432@count0.beaverton.ibm.com>
 <4D535627.9090606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D535627.9090606@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@linux.intel.com> [2011-02-09 19:06:15]:

> On 2/9/2011 7:04 PM, Matt Helsley wrote:
> >On Tue, Feb 08, 2011 at 05:05:41PM -0800, jacob.jun.pan@linux.intel.com wrote:
> >>From: Jacob Pan<jacob.jun.pan@linux.intel.com>
> >>
> >>Freezer subsystem is used to manage batch jobs which can start
> >>stop at the same time. However, sometime it is desirable to let
> >>the kernel manage the freezer state automatically with a given
> >>duty ratio.
> >>For example, if we want to reduce the time that backgroup apps
> >>are allowed to run we can put them into a freezer subsystem and
> >>set the kernel to turn them THAWED/FROZEN at given duty ratio.
> >>
> >>This patch introduces two file nodes under cgroup
> >>freezer.duty_ratio_pct and freezer.period_sec
> >>
> >>Usage example: set period to be 5 seconds and frozen duty ratio 90%
> >>[root@localhost aoa]# echo 90>  freezer.duty_ratio_pct
> >>[root@localhost aoa]# echo 5000>  freezer.period_ms
> >I kept wondering how this was useful when we've got the "cpu" subsystem
> >because for some reason "duty cycle" made me think this was a scheduling
> >policy knob. In fact, I'm pretty sure it is -- it just happens to
> >sometimes reduce power consumption.
> >
> >Have you tried using the cpu cgroup subsystem's share to see if it can
> >have a similar effect?
> 
> does the cpu cgroup system work on a 20 to 30 second time window?
> the objective is to have the CPU idle, without wakeups, for that long...
> (to save power)

This is an interesting idea to force idle.  The cpu cgroup will
maintain resource ratio but will not restrict runtime of a cgroup if
there is nothing else to run in the system.

CFS hardlimits (http://lwn.net/Articles/368685/) can do something like
this but will need to be tuned for long intervals.  On multi cpu
system, synchronising the idle times across cpus has been the key
challenge that reduces the power saving benefits.

Does this technique provide good power savings for a specific
usecase/workload or platform?

--Vaidy

