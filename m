Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1BYV4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:56:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:55642 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BYV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:56:12 -0500
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Gibson <david@gibson.dropbear.id.au>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
In-Reply-To: <AANLkTi=Oh0iu-d4n3rMLvXFH-DjS1mT3GgpoJyywjM=5@mail.gmail.com>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
	 <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
	 <20110223000759.GA26300@yookeroo> <4D653CF1.30009@caviumnetworks.com>
	 <20110224231923.GB18233@yookeroo>
	 <AANLkTi=Oh0iu-d4n3rMLvXFH-DjS1mT3GgpoJyywjM=5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 08:46:22 +1100
Message-ID: <1298670382.8833.693.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 08:22 -0700, Grant Likely wrote:
> 
> Generally I've applied the argument that it's a good idea to populate
> the /cpus node as an anchor for future things that might require it.
> For example, a theoretical hypervisor which doesn't allow the guest
> access to all the CPUs would use cpu nodes to tell the OS 'hands off'.
>  Or possibly more likely, and AMP scenario where Linux would certainly
> detect all the CPUs, but is supposed to leave some of them alone.  It
> would also be an anchor for anything NUMA-like which is also
> theoretical, but may become more likely in some of the larger ARM
> designs that I've been hearing about.

It also allows to bring other informations in there such as clock
frequencies etc... In some kind, binding to a reset GPIO used to soft
reset secondaries (ie on Macs we have something like that)...

> Given that we've been very explicit that the device tree is for
> describing things that aren't probable, the argument that it is not
> necessary to populate the cpus node probably holds some water.  If
> there are no special considerations (ie. disabled CPUs or NUMA) and
> nothing holds a phandle to a specific cpu node, then it is probably
> okay to omit.  In that case the lack of /cpus node would mean simply,
> "detect the cpus", and /cpus could be populated to override the
> detected behaviour.

Well... I tend to recommend putting things that are soldered on the mobo
in the device-tree, simply because that allows to pass all sort of
additional informations that can be useful. For example, if you have a
PCI2PCI bridge on the mobo, it allows you to provide proper slot names
for the slots below it, or if devices have oddly routed interrupts (not
the standard INTA...D with swizzling), which happens on embedded a lot,
the device-tree can convey that more easily.

Other things like clock frequencies or in general clock relationships,
or even location codes, MAC addresses, etc... 

But you don't -have- to. It's just a recommendation.

> Picking up on something David Daney said...
> >> The number and type of CPUs can be (and is) probed.  There is an
> >> existing mechanism for the bootloader to communicate which CPUs
> >> should be used.
>
> I do get a little nervous about this (the bootloader communication
> bit).  For ARM, I had an argument with Nicolas Pitre about preserving
> the existing ATAGs mechanism and adding DT on top vs. replacing ATAGs
> entirely with DT.  I wanted to keep ATAGs, but Nicolas was concerned
> about how to handle ambiguity about which data to use when the ATAGs
> and DT disagree.  In hindsight Nicolas was 100% right and I'm glad he
> pushed back.  The ARM DT support now detects if ATAGs or a .dtb were
> passed at boot (one or the other), and it is *so* much cleaner.  All
> configuration data lives in the same place and is manipulated in the
> same way.  Plus it means that the dt usage model is the same for
> multiple architectures, arm, powerpc and microblaze. 

I think doing a "blend" of existing bootloader channels + device-tree is
bad. The device-tree should convey all of the informations that were
previously passed using a different mechanism, or hell will freeze over
in the long run.

Cheers,
Ben.


