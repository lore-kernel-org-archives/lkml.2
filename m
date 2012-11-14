Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2KNAHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:07:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44150 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab2KNAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:07:40 -0500
Date: Tue, 13 Nov 2012 16:03:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121114000339.GL2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <20121113222350.GH2489@linux.vnet.ibm.com>
 <50A2CD77.7000403@linux.intel.com>
 <21157900.tI2QCFTxxq@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21157900.tI2QCFTxxq@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111400-8974-0000-0000-00001114D3A0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00191082; UDB=6.00043255; UTC=2012-11-14
 00:07:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:02:00AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 13, 2012 02:45:11 PM Arjan van de Ven wrote:
> > On 11/13/2012 2:23 PM, Paul E. McKenney wrote:
> > > On Tue, Nov 13, 2012 at 01:39:22PM -0800, Jacob Pan wrote:
> > >> On Tue, 13 Nov 2012 13:16:02 -0800
> > >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > >>
> > >>>> Please refer to Documentation/thermal/intel_powerclamp.txt for more
> > >>>> details.  
> > >>>
> > >>> If I read this correctly, this forces a group of CPUs into idle for
> > >>> about 600 milliseconds at a time.  This would indeed delay grace
> > >>> periods, which could easily result in user complaints.  Also, given
> > >>> the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
> > >>> RCU_BOOST, you would see needless RCU priority boosting.
> > >>>
> > >> the default idle injection duration is 6ms. we adjust the sleep
> > >> interval to ensure idle ratio. So the idle duration stays the same once
> > >> set. So would it be safe to delay grace period for this small amount in
> > >> exchange for less over head in each injection period?
> > > 
> > > Ah, 6ms of delay is much better than 600ms.  Should be OK (famous last
> > > words!).
> > 
> > well... power clamping is not "free".
> > You're going to lose performance as a trade off for dropping instantaneous power consumption....
> 
> Yes.  It is good to realize that when the clamping triggers, we already
> have some more to worry about than losing some performance. :-)
> 
> The problem here is to find a way to lose as little performance as we possibly
> can and prevent the system from overheating at the same time.

Understood.  My concern is in-kernel confusion rather than performance.

							Thanx, Paul

