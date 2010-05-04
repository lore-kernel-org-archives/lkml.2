Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab0EDXwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:52:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40434 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0EDXwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:52:14 -0400
MIME-Version: 1.0
Message-ID: <691ab2ec-380b-4294-bab3-53fbf3fa33fc@default>
Date: Tue, 4 May 2010 16:51:01 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com
Subject: RE: [RFC] Exposing TSC "reliability" to userland
References: <18849d97-2fee-43a0-a3ea-9132f8163609@default
 m2z3055132f1005041616r2d6a9747i32b8187912049182@mail.gmail.com>
In-Reply-To: <m2z3055132f1005041616r2d6a9747i32b8187912049182@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE0B31C.008A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Running a warp test in userland is not nearly as accurate
> > as the warp test run by the kernel.  So it makes sense to expose
> > the results of the kernel warp test to userland, maybe
> > through /sys/devices/system/clocksource/tsc_reliable
> >
> > Comments?
> 
> [ Sorry if this is a duplicate. I had messed up my mail client format
> setting ]
> 
> One option is to remove tsc from
> /sys/devices/system/clocksource/clocksource*/available_clocksource
> when it is detected as unstable.
> 
> That should already be happening with NOHZ or HIGHRES selected. But,
> should be simple to add some code to do this always.
> 
> Would that work?

Hi Venki --

In some offlist discussion, a similar solution was suggested:
If /sys/devices/system/clocksource/clocksource*/current_clocksource
is "tsc" AND the "Invariant TSC" CPUID bit is set, then "reliable TSC"
can be assumed.

BUT, exposing the information explicitly from the kernel would be
more comforting rather than requiring some reverse-engineering some
combination of kernel tests that might change over time.  If the
kernel determines TSC is reliable, that seems like it should be
good enough for userland.

AND it was also pointed out that userland usage of TSC is almost
useless unless some reliable reasonably-precise frequency is also
known.  A possible solution to this is to expose:

/sys/devices/system/clocksource/clocksource*/clocksource_mult and
/sys/devices/system/clocksource/clocksource*/clocksource_shift

(or some other more TSC-specific name) and provide the same
mult/shift values the kernel uses for clocksource_cyc2ns().

By the way, excuse my ignorance, but is there ever a clocksourceN
where N is not zero?

Hope things are going well in google-land!

Thanks,
Dan
