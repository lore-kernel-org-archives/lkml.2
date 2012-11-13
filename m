Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2KMW5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:57:42 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab2KMW5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:57:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: paulmck@linux.vnet.ibm.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Date: Wed, 14 Nov 2012 00:02 +0100
Message-ID: <21157900.tI2QCFTxxq@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50A2CD77.7000403@linux.intel.com>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com> <20121113222350.GH2489@linux.vnet.ibm.com> <50A2CD77.7000403@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 02:45:11 PM Arjan van de Ven wrote:
> On 11/13/2012 2:23 PM, Paul E. McKenney wrote:
> > On Tue, Nov 13, 2012 at 01:39:22PM -0800, Jacob Pan wrote:
> >> On Tue, 13 Nov 2012 13:16:02 -0800
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >>>> Please refer to Documentation/thermal/intel_powerclamp.txt for more
> >>>> details.  
> >>>
> >>> If I read this correctly, this forces a group of CPUs into idle for
> >>> about 600 milliseconds at a time.  This would indeed delay grace
> >>> periods, which could easily result in user complaints.  Also, given
> >>> the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
> >>> RCU_BOOST, you would see needless RCU priority boosting.
> >>>
> >> the default idle injection duration is 6ms. we adjust the sleep
> >> interval to ensure idle ratio. So the idle duration stays the same once
> >> set. So would it be safe to delay grace period for this small amount in
> >> exchange for less over head in each injection period?
> > 
> > Ah, 6ms of delay is much better than 600ms.  Should be OK (famous last
> > words!).
> 
> well... power clamping is not "free".
> You're going to lose performance as a trade off for dropping instantaneous power consumption....

Yes.  It is good to realize that when the clamping triggers, we already
have some more to worry about than losing some performance. :-)

The problem here is to find a way to lose as little performance as we possibly
can and prevent the system from overheating at the same time.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
