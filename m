Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2IVQAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 12:00:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47198 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2IVQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 12:00:40 -0400
Date: Sat, 22 Sep 2012 09:00:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120922160031.GC2934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
 <20120921203149.GI28835@atomide.com>
 <20120921220302.GF2454@linux.vnet.ibm.com>
 <CAFTL4hy5wO9CL5_1e8U7L3Tihm_HYD6uAsda3ue-zDKFjir2Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy5wO9CL5_1e8U7L3Tihm_HYD6uAsda3ue-zDKFjir2Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092216-2398-0000-0000-00000B47F2FB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00176347; UDB=6.00039933; UTC=2012-09-22
 16:00:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 05:45:12PM +0200, Frederic Weisbecker wrote:
> 2012/9/22 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Fri, Sep 21, 2012 at 01:31:49PM -0700, Tony Lindgren wrote:
> >> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [120921 12:58]:
> >> >
> >> > Just to make sure I understand the combinations:
> >> >
> >> > o   All stalls have happened when running a minimal userspace.
> >> > o   CONFIG_NO_HZ=n suppresses the stalls.
> >> > o   CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
> >> >     no observable effect on the stalls.
> >>
> >> The reason why you may need minimal userspace is to cut down
> >> the number of timers waking up the system with NO_HZ.
> >> Booting with init=/bin/sh might also do the trick for that.
> >
> > Good point!  This does make for a very quiet system, but does not
> > reproduce the problem under kvm, even after waiting for four minutes.
> > I will leave it for more time, but it looks like I really might need to
> > ask Linaro for remote access to a Panda.
> 
> I have one. I'm currently installing Ubuntu on it and I'll try to
> manage to build
> a kernel and reproduce the issue.
> 
> I'll give more news soon.

Thank you!

My bet is that you have to have a userspace that is so small that it
registers only a few (but at least one!) RCU callback at boot time,
then never registers any callbacks ever again.  I have coded up a
crude test case, using Tony Lindgren's suggestion of "init=/bin/sh",
but I appear to have inadvertently fixed this bug in current -rcu
(git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git,
branch rcu/next).

But I have been wrong a few times already on this particular bug...

							Thanx, Paul

