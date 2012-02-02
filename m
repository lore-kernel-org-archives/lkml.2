Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2BBR6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:58:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47177 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2BBR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:58:05 -0500
Date: Thu, 2 Feb 2012 09:56:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 30/41] rcutorture: Permit holding off
 CPU-hotplug operations during boot
Message-ID: <20120202175646.GW2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-30-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202054259.GQ29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202054259.GQ29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-6148-0000-0000-0000031B2814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 09:43:00PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:48AM -0800, Paul E. McKenney wrote:
> > When rcutorture is started automatically at boot time, it might well
> > also start CPU-hotplug operations at that time, which might not be
> > desirable.  This commit therefore adds an rcutorture parameter that
> > allows CPU-hotplug operations to be held off for the specified number
> > of seconds after the start of boot.
> > --- a/Documentation/RCU/torture.txt
> > +++ b/Documentation/RCU/torture.txt
> > @@ -271,11 +278,13 @@ The following script may be used to torture RCU:
> >  	#!/bin/sh
> >  
> >  	modprobe rcutorture
> > -	sleep 100
> > +	sleep 3600
> >  	rmmod rcutorture
> >  	dmesg | grep torture:
> 
> This looks like an entirely unrelated change.

I suppose it is.  I did split it out, though a one-line documentation change
seems a bit lightweight for a commit.

								Thanx, Paul

