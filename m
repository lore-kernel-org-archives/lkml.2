Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0K2Cdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:33:53 -0500
Received: from ozlabs.org ([203.10.76.45]:34826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0K2Cdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:33:52 -0500
Date: Mon, 29 Nov 2010 13:22:08 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101129022208.GA3727@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
 <1290808645.32570.158.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290808645.32570.158.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 08:57:25AM +1100, Benjamin Herrenschmidt wrote:
> 
> > + */
> > +/dts-v1/;
> > +/ {
> > +	model = "x86,CE4100";
> > +	compatible = "x86,CE4100";
> 
> Use a vendor name rather than "x86" here.
> 
> > +	#address-cells = <1>;
> > +	#size-cells = <1>;
> > +
> > +	cpus {
> > +		x86,Atom@0 {
> 
> "Atom" would benefit from being more precise, like adding the model
> number. Also you want some properties there defining maybe the mask, the
> cache characteristics, etc... There's an exising OFW binding for x86, I
> suppose you could follow it. A "reg" property at least is mandatory
> here.

In the PowerPC flat-tree world, the newly established convention is to
extend the generic names convention to cpu nodes, so we name the nodes
just "cpu@0" etc. and move the more specific cpu type ("PowerPC,970FX"
/ "x86,Atom" / whatever) to the compatible property.  I'd recommend
this convention to you, even though it's a bit of a break from earlier
standard practice, it makes device tree manipulations by bootloaders
and other intermediate things a bit easier.

> Also how do you plan to expose threading capability ?

Unless the existing x86 bindings specify something different, I'd
suggest the method we're planning to put into ePAPR 1.1 for PowerPC
chips.  That is, threads sharing an MMU go in the same cpu node, with
the individual thread numbers given as multiple entries in the "reg"
property.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
