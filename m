Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0K3AET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:04:19 -0500
Received: from ozlabs.org ([203.10.76.45]:42446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0K3AER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:04:17 -0500
Date: Tue, 30 Nov 2010 10:58:52 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, sodaville@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101129235852.GC3604@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Scott Wood <scottwood@freescale.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	sodaville@linutronix.de,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
 <1290808645.32570.158.camel@pasglop>
 <20101128160449.GC30784@www.tglx.de>
 <1290984809.32570.208.camel@pasglop>
 <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 01:07:20PM -0600, Scott Wood wrote:
> On Mon, 29 Nov 2010 09:53:29 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > On Sun, 2010-11-28 at 17:04 +0100, Sebastian Andrzej Siewior wrote:
> > > >> +	isa@legacy {
> 
> What is "@legacy"?  I don't think I've seen that in a unit address
> before, googling only turns up this device tree, and a quick grep
> through the ISA and base OF specs turns up nothing.
> 
> > > >> +		device_type = "isa";
> > > >> +		compatible = "simple-bus";
> > > >
> > > >What does "simple-bus" means ?
> > > I added simple bus in order to get probed. But I now I rember that this
> > > is also supported per device_type. I get rid of it.
> > 
> > device_type is a nasty bugger, we are trying to get rid of Linux
> > reliance on it.
> > 
> > Things like "simple-bus" don't rock my boat either, it's adding to the
> > device-tree "informations" that are specific to the way Linux will
> > interpret it, which is not how it should be.
> 
> The motivation for simple-bus comes from Linux, but its definition is
> OS-neutral.  It indicates that no special bus knowledge is required to
> access the devices under it.

Well, sort of.  More specifically, that plus it indicates that the bus
does not support any method of dynamic probing, so the device tree is
the *only* way to figure out what's on it.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
