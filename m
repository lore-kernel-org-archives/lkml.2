Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab0HFRW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:22:56 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50945 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761621Ab0HFRWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:22:52 -0400
Date: Fri, 6 Aug 2010 10:22:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100806172226.GH2432@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100805203102.GN2447@linux.vnet.ibm.com>
 <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
 <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
 <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
 <20100805230304.GQ2447@linux.vnet.ibm.com>
 <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com>
 <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
 <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
 <20100806123047.GE31326@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806123047.GE31326@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:30:48PM +0100, Mark Brown wrote:
> On Thu, Aug 05, 2010 at 06:01:24PM -0700, david@lang.hm wrote:
> > On Thu, 5 Aug 2010, Brian Swetland wrote:
> 
> >> Obviously not all clocks are stopped (the DSP and codec are powered
> >> and clocked, for example), but yeah we can clock gate and power gate
> >> the cpu and most other peripherals while audio is playing on a number
> >> of ARM SoC designs available today (and the past few years).
> 
> > does this then mean that you have multiple variations of suspend?
> 
> > for example, one where the audio stuff is left powered, and one where it  
> > isn't?
> 
> This was the core of the issue I was raising in the last thread about
> this (the one following the rename to suspend blockers).  Essentially
> what happens in a mainline context is that some subsystems can with
> varying degress of optionality ignore some or all of the instruction to
> suspend and keep bits of the system alive during suspend.
> 
> Those that stay alive will either have per subsystem handling or will be
> outside the direct control of the kernel entirely (the modem is a good
> example of the latter case in many systems - in terms of the software
> it's essentially a parallel computer that's sitting in the system rather
> than a perhiperal of the AP).

This underscores a basic difference between servers and these embedded
devices.  When you suspend a server, it is doing nothing, because servers
rely very heavily on the CPUs.  In contrast, many embedded devices can
perform useful work even when the CPUs are completely powered down.

							Thanx, Paul
