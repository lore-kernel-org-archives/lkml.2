Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1EEAoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:44:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:59203 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1EEAoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:44:00 -0400
Subject: Re: [PATCH 4/6] dt: generalize irq_of_create_mapping()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20110504160502.GC3317@ponder.secretlab.ca>
References: <20110428192227.8979.49181.stgit@ponder>
	 <20110428200203.8979.3569.stgit@ponder> <1304387422.2513.301.camel@pasglop>
	 <20110504160502.GC3317@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 10:43:41 +1000
Message-ID: <1304556221.2513.395.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 10:05 -0600, Grant Likely wrote:
> > I think you are going the wrong way around.
> > 
> > First thing first, is to make the irq domain / mapping API generic
> > without the OF bits.
> > 
> > IE. move the IRQ domain generically, get rid of irq_map by putting
> the
> > domain ptr & hw numbers in the irq desc/data etc...
> > 
> > Then you can move over the OF specific bits which are optional and
> > orthogonal to a large extent.
> 
> As discussed in my other reply, I disagree.  There isn't an immediate
> need for the mapping interface in common code.  It would be useful,
> sure, for some interrupt controllers, but for many of them
> irq_alloc_descs() and an irq_base value is all the functionality that
> is needed, and irq_host doesn't gain anything.

No but the concept of domain is a pre-requisite. Even if it's an opaque
data structure. And I don't want to have it be some "of" specific thing.

> The OF translation on the other hand is needed immediately by several
> architectures and are very much non-optional in that regard.

But it relies on having an underlying mapping. I don't see how you can
do one without the other, even if your mapping in effect is just an
offset.

And it is -not- related to OF.

Whether you obtain that your interrupt you are interested it is
interrupt 5 of your PIC "foo" via the device-tree or any other way (an
arch quirk for example), you need the mechanism to associate them
together, whether it's a simple offset as you propose (I'm ok with that
for simple things, I just didn't think it was the right approach for
powerpc but it's perfectly valid as an option generically) or a more
complex radix-tree style mapping.

Thus sort out the mapping interfaces first. _Then_ layout the
device-tree bits on top.

The basic parsing for the DT is already there. It will return a parent
node and a __be32* pointer.

Cheers,
Ben.

