Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1JCMRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:17:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755571Ab1JCMQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:16:58 -0400
Date: Mon, 3 Oct 2011 13:16:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20111003121655.GB3731@opensource.wolfsonmicro.com>
References: <20110927181420.GQ4289@opensource.wolfsonmicro.com>
 <CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
 <20110927182636.GR4289@opensource.wolfsonmicro.com>
 <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
 <20110927183832.GS4289@opensource.wolfsonmicro.com>
 <CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
 <20110928123154.GG3279@opensource.wolfsonmicro.com>
 <CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
 <20111003102846.GA23811@sirena.org.uk>
 <CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:39:47AM +0100, Daniel Drake wrote:
> On Mon, Oct 3, 2011 at 11:28 AM, Mark Brown

> > I'd really expect that if we're adding stuff to the framework then it
> > should be suitable for random drivers to use.

> It is suitable. If other drivers would otherwise run into the data
> reuse problem you have described, they can use the kmemdup solution
> you have described.

This seems the wrong way round - we're working

> > To be honest I don't
> > really understand why you're changing the framework at all here, the
> > child driver is entirely specific to the parent as far as I can see.

> Because I'm trying to get devicetree-driven HDD LED support driven,
> and Grant stated that doing it this way is a hard rule:

> "What is a hard rule is that the code creating the children needs to
> know what the binding is and populate the child's of_node
> appropriately."

> I also confirmed that extending the mfd_cell layer is exactly what
> Grant was suggesting:
> http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-September/008480.html

That's in the context of adding a binding for the vx855 GPIO module
that's distinct from the binding for the rest of the chip.  It's not
massively clear to me that this is a good idea.

> So I seem to be stuck between two people giving me conflicting
> requirements for merge of my work (which commenced in July, and has
> already seen several discussions and rounds of patches). Any help
> appreciated - I'm just trying to make a HDD LED blink.

It seems to me like either the IP block is heavily dependant on the core
and shouldn't be split out in the device tree at all (but should instead
be part of the core node) or the IP block is very isolated from the core
(in which case we should just be able to instantiate the device from the
device tree without using explict code in the core driver).

This all feels like there's some abstraction violation going on.
