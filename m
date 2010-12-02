Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0LBQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:15:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab0LBQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:15:15 -0500
Date: Thu, 2 Dec 2010 11:15:02 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101202161502.GL18100@redhat.com>
References: <1291219906.32004.1671.camel@laptop>
 <20101201162335.GB2511@redhat.com>
 <1291232292.32004.1969.camel@laptop>
 <20101201194644.GD2511@redhat.com>
 <1291232989.32004.1987.camel@laptop>
 <20101201195835.GE2511@redhat.com>
 <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291275270.4023.20.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 08:34:30AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-02 at 00:23 -0500, Don Zickus wrote:
> > On Wed, Dec 01, 2010 at 01:48:07PM -0800, Eric W. Biederman wrote:
> > > >
> > > > Oh, but I'm not a device or sysdev thing, I'll never get something like
> > > > that.
> > > 
> > > There is also the reboot notifier, if the NMI needs to be controlled
> > > outside of device model.  Sigh. The NMI handling is such a special case.
> > 
> > I tried reboot notifiers with the nmi_watchdog and acheived some success
> > (on a Westmere box, a P4 still failed).  Kdump is still screwed, but maybe
> > we don't care for now.
> > 
> > Here is the quick and dirty patch I used.
> 
> 
> We'd really want a perf_event.c callback there to do as the hot-unplug
> code does and detach all running counters from the cpu.

Ok, I moved the reboot notifier stuff from kernel/watchdog.c to
kernel/perf_event.c.  Things still worked fine from a kexec perspective.

Vivek suggested to me this morning that I should just blantantly disable the
perf counter during init when running my test.  Looking through the code I
don't think I can do this using disable_all because some routines look for
the active bit to be set and some arches have different disable registers
than others.  Thoughts?

Cheers,
Don
