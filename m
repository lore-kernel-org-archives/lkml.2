Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab0HESVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:21:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46230 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0HESVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:21:17 -0400
Date: Thu, 5 Aug 2010 11:21:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: david@lang.hm, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805182111.GK2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com>
 <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
 <20100805001716.GO24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
 <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
 <20100805151211.GA10080@linux.vnet.ibm.com>
 <20100805160912.GA28689@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805160912.GA28689@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 05:09:17PM +0100, Mark Brown wrote:
> On Thu, Aug 05, 2010 at 08:12:11AM -0700, Paul E. McKenney wrote:
> > On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
> 
> > > as for intramentation, the key tool to use to see why a system isn't
> > > going to sleep would be powertop, just like on other linux systems.
> 
> > Powertop is indeed an extremely valuable tool, but I am not certain
> > that it really provides the information that the Android guys need.
> > If I understand Arve's and Brian's posts, here is the scenario that they
> > are trying to detect:
> 
> > o	Some PM-driving application has a bug in which it fails to
> > 	release a wakelock, thus blocking suspend indefinitely.
> 
> > o	This PM-driving application, otherwise being a good citizen,
> > 	blocks.
> 
> > o	There are numerous power-oblivious apps running, consuming
> > 	significant CPU.
> 
> Or otherwise doing something power hungry.
> 
> > What the Android developers need to know is that the trusted application
> > is wrongly holding a wakelock.  Won't powertop instead tell them about
> > all the power-oblivious apps?
> 
> Right, and this isn't just information for developers - Android handsets
> expose this information to end users (so they can indentify any badly
> behaved applications they have installed or otherwise modify their
> handset usage if they are disappointed by their battery life).  That
> said, powertop and similar applications could always be extended to also
> include data from wakelocks.

Good point!!!  Of course, powertop would need to interact with Android's
user-level daemon for this to work, but perhaps this could be arranged.
(There is a user-level daemon in Android that acquires kernel-level
suspend blockers on behalf of applications, so a naive mod to powertop
would just finger the user-level daemon.)

							Thanx, Paul
