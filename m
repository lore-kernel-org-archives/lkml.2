Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab0HEQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:09:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56129 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0HEQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:09:24 -0400
Date: Thu, 5 Aug 2010 17:09:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: david@lang.hm, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805160912.GA28689@sirena.org.uk>
References: <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com> <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm> <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm> <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805151211.GA10080@linux.vnet.ibm.com>
X-Cookie: If it ain't baroque, don't phiques it.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 08:12:11AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:

> > as for intramentation, the key tool to use to see why a system isn't
> > going to sleep would be powertop, just like on other linux systems.

> Powertop is indeed an extremely valuable tool, but I am not certain
> that it really provides the information that the Android guys need.
> If I understand Arve's and Brian's posts, here is the scenario that they
> are trying to detect:

> o	Some PM-driving application has a bug in which it fails to
> 	release a wakelock, thus blocking suspend indefinitely.

> o	This PM-driving application, otherwise being a good citizen,
> 	blocks.

> o	There are numerous power-oblivious apps running, consuming
> 	significant CPU.

Or otherwise doing something power hungry.

> What the Android developers need to know is that the trusted application
> is wrongly holding a wakelock.  Won't powertop instead tell them about
> all the power-oblivious apps?

Right, and this isn't just information for developers - Android handsets
expose this information to end users (so they can indentify any badly
behaved applications they have installed or otherwise modify their
handset usage if they are disappointed by their battery life).  That
said, powertop and similar applications could always be extended to also
include data from wakelocks.
