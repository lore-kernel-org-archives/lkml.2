Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab0HDUw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:52:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801Ab0HDUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:52:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Wed, 4 Aug 2010 22:51:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org>
In-Reply-To: <20100804185520.GA2417@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042251.08266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 04, 2010, Matthew Garrett wrote:
> On Wed, Aug 04, 2010 at 11:30:44AM -0700, david@lang.hm wrote:
> > a couple days ago I made the suggestion to put non-privilaged tasks in a  
> > cgroup so that the idle/suspend decision code could ignore acitivity  
> > caused by this cgroup.
> >
> > in the second version wakeup events would be 'activity' that would be  
> > counted and therefor the system would not be idle. As for the race with  
> > suspending and new things happening, wouldn't that be handled the same 
> > way that it is in a normal linux box?
> 
> No! And that's precisely the issue. Android's existing behaviour could 
> be entirely implemented in the form of binary that manually triggers 
> suspend when (a) the screen is off and (b) no userspace applications 
> have indicated that the system shouldn't sleep, except for the wakeup 
> event race. Imagine the following:
> 
> 1) The policy timeout is about to expire. No applications are holding 
> wakelocks. The system will suspend providing nothing takes a wakelock.
> 2) A network packet arrives indicating an incoming SIP call
> 3) The VOIP application takes a wakelock and prevents the phone from 
> suspending while the call is in progress
> 
> What stops the system going to sleep between (2) and (3)? cgroups don't, 
> because the voip app is an otherwise untrusted application that you've 
> just told the scheduler to ignore.

I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
avoid the race (if pm_wakeup_event() is called at 2)).

Thanks,
Rafael
