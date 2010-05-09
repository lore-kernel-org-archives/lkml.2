Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0EIJL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 05:11:56 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:60594 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564Ab0EIJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 05:11:54 -0400
Date: Sun, 9 May 2010 11:11:51 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.33 & 2.6.34-rc6: Huge number of Load Balancing
	tick wakeups.
Message-ID: <20100509091151.GA24453@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Nigel Cunningham <ncunningham@crca.org.au>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Len Brown <lenb@kernel.org>,
	Linux Power Management List <linux-pm@lists.osdl.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4BE4F5DF.70903@crca.org.au> <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain> <4BE5F3B2.6070901@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE5F3B2.6070901@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, May 09, 2010 at 09:28:50AM +1000, Nigel Cunningham wrote:
> On 09/05/10 05:16, Len Brown wrote:
> > (linux-pm cc'd)
> >
> >> I'm seeing a huge number of load balancing tick wakeups, with both 2.6.33 and
> >> current git (f1c448e0a9e99c76f4ece368714fb35a40a8daba).
> >>
> >> This has been reported as a bug in some distros:
> >>
> >> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=521944
> >> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/524281
> >
> > Unclear if your sighting is the same as those two.
> >
> > What do you see if vmware is not present?
> 
> I still see a huge number, just not as huge. The number of load 
> balancing ticks seems to increase with the number of ticks from other 
> sources. Without vmware running I got:
> 
> Cn	          Avg residency
> C0 (cpu running)        (14.5%)
> polling		  0.2ms ( 0.0%)
> C1 mwait	  0.0ms ( 0.0%)
> C2 mwait	  0.1ms ( 1.7%)
> C4 mwait	  1.1ms (83.8%)
> P-states (frequencies)
> Turbo Mode     1.2%
>    2.21 Ghz     0.0%
>    1.60 Ghz     0.0%
>    1200 Mhz     0.1%
>     800 Mhz    98.7%
> Wakeups-from-idle per second : 907.4	interval: 15.0s
> no ACPI power usage estimate available
> Top causes for wakeups:
>    42.1% (435.6)   [kernel scheduler] Load balancing tick
>    21.2% (219.6)   [extra timer interrupt]
>    10.2% (105.6)   plugin-containe
>     9.5% ( 98.1)   pulseaudio
>     1.7% ( 17.9)   [Rescheduling interrupts] <kernel IPI>
>     1.7% ( 17.1)   [iwl3945] <interrupt>
>     1.4% ( 14.8)   [kernel core] hrtimer_start (tick_sched_timer)
>     1.4% ( 14.3)   [ata_piix] <interrupt>

Seems to be exactly what I'm seeing here, too. See my description and
possible patch at

	http://lkml.org/lkml/2010/4/26/249

Suresh Siddha reported he's working on getting some (more advanced) patches
ready for submission.

Best,
	Dominik
