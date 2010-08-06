Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934992Ab0HFRda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:33:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54748 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713Ab0HFRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:33:28 -0400
Date: Fri, 6 Aug 2010 18:33:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20100806173325.GA25367@rakim.wolfsonmicro.main>
References: <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
 <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
 <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
 <20100805230304.GQ2447@linux.vnet.ibm.com>
 <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com>
 <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
 <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
 <20100806123047.GE31326@sirena.org.uk>
 <20100806172226.GH2432@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806172226.GH2432@linux.vnet.ibm.com>
X-Cookie: An idle mind is worth two in the bush.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 10:22:26AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 06, 2010 at 01:30:48PM +0100, Mark Brown wrote:

> > this (the one following the rename to suspend blockers).  Essentially
> > what happens in a mainline context is that some subsystems can with
> > varying degress of optionality ignore some or all of the instruction to
> > suspend and keep bits of the system alive during suspend.

> This underscores a basic difference between servers and these embedded
> devices.  When you suspend a server, it is doing nothing, because servers
> rely very heavily on the CPUs.  In contrast, many embedded devices can
> perform useful work even when the CPUs are completely powered down.

Well, not really from the Linux point of view.  It's not massively
different to something like keeping an ethernet controller sufficiently
alive to allow it to provide wake on LAN functionality while the system
is suspended in terms of what Linux has to do, and quite a few servers
have lights out management systems which aren't a million miles away
from the modem on a phone in terms of their relationship with the host
computer.
