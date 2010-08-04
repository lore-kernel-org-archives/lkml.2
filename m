Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab0HDU5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:57:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52099 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934551Ab0HDU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:57:19 -0400
Date: Wed, 4 Aug 2010 21:56:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804205654.GA4986@srcf.ucam.org>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008042251.08266.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, August 04, 2010, Matthew Garrett wrote:
> > No! And that's precisely the issue. Android's existing behaviour could 
> > be entirely implemented in the form of binary that manually triggers 
> > suspend when (a) the screen is off and (b) no userspace applications 
> > have indicated that the system shouldn't sleep, except for the wakeup 
> > event race. Imagine the following:
> > 
> > 1) The policy timeout is about to expire. No applications are holding 
> > wakelocks. The system will suspend providing nothing takes a wakelock.
> > 2) A network packet arrives indicating an incoming SIP call
> > 3) The VOIP application takes a wakelock and prevents the phone from 
> > suspending while the call is in progress
> > 
> > What stops the system going to sleep between (2) and (3)? cgroups don't, 
> > because the voip app is an otherwise untrusted application that you've 
> > just told the scheduler to ignore.
> 
> I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
> avoid the race (if pm_wakeup_event() is called at 2)).

Yes, I think that solves the problem. The only question then is whether 
it's preferable to use cgroups or suspend fully, which is pretty much up 
to the implementation. In other words, is there a reason we're still 
having this conversation? :) It'd be good to have some feedback from 
Google as to whether this satisfies their functional requirements.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
