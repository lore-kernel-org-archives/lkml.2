Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1CAUXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:23:05 -0500
Received: from www.tglx.de ([62.245.132.106]:41443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab1CAUXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:23:03 -0500
Date: Tue, 1 Mar 2011 21:22:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Performance/resume issues on Toshiba NB305
In-Reply-To: <20110301200446.GA2235@thinkpad-t410>
Message-ID: <alpine.LFD.2.00.1103012117010.2701@localhost6.localdomain6>
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410> <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6> <20110301200446.GA2235@thinkpad-t410>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Seth Forshee wrote:
> On Fri, Feb 25, 2011 at 10:47:16PM +0100, Thomas Gleixner wrote:
> > On Fri, 25 Feb 2011, Seth Forshee wrote:
> > > On Fri, Feb 25, 2011 at 09:37:39PM +0100, Thomas Gleixner wrote:
> > > > On Fri, 25 Feb 2011, Seth Forshee wrote:
> > > > That seems to be related to low power states. When the machine goes
> > > > idle we switch into lower power states and that requires to use the
> > > > hpet instead of the local apic timer as that one stops.
> > > > 
> > > > You could verify that theory by booting with processor.max_cstate=1
> > > 
> > > This fixes the performance in combination with intel_idle.max_cstate=0.
> > > Alternately, intel_idle.max_cstate=1 works. But the resume still hangs.
> > 
> > That was expected :)
> > 
> > > Is the answer to quirk the machine to avoid deep C-states, or is there
> > > some better way I can fix this?
> > 
> > Let's wait for the intel and acpi folks. It would be interesting what
> > the new intel toy says to your BIOS.
> 
> Since the discussion on this issue died without really getting anywhere,
> I went ahead and threw together the patch below to disable anything
> deeper than C1 for this machine. I hope a better solution can be found,
> but if not would something like this be an acceptable workaround?
> 
> As for the hangs during resume, unless someone has a better suggestion I
> guess I'll start looking into forcing the HPET to remain in periodic
> mode throughout suspend.

The problem with such DMI quirks is that it's hard to get rid of them
when a fixed BIOS version comes out while simply adding nohpet to the
kernel command line, is a non permanent, but sensible workaround.

Thanks,

	tglx


