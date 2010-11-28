Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0K1WyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:54:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:60020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab0K1WyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:54:11 -0500
Subject: Re: [PATCH 07/11] x86/dtb: add support for PCI devices backed by
 dtb nodes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20101128140436.GB30784@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-8-git-send-email-bigeasy@linutronix.de>
	 <1290897231.32570.168.camel@pasglop>  <20101128140436.GB30784@www.tglx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 09:32:06 +1100
Message-ID: <1290983526.32570.187.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 15:04 +0100, Sebastian Andrzej Siewior wrote:
> Microblaze had its own copy of this code so I though there is
> something
> specific about it. If it is okay with you, I would move it to
> drivers/of
> and share. Then I would have the swizzle part :)

Appart from the accessor pci_device_to_OF_node() which might or might
not be specific, I thin the code is pretty common, probably something
Grant didn't have time to tackle yet :-)
 
> >Eventually we want that matching between PCI devices and OF nodes to
> be
> >in generic code, so that's not a big deal to have an "inferior"
> version
> >temporarily in there I suppose.
> 
> Inferior, I see :)

Hehe yeah :-) It's actually not a simple problem. For example, we can't
just move the powerpc variant over to generic code as-is bcs ... we have
2 completely different ways of doing it between ppc32 and ppc64 for
historical reasons :-) They also have different "features". This is
something I need to reconcile at some stage.

For example our ppc32 variant support bus renumbering (ie, Linux
assigning different bus numbers than what the DT encodes) while our
ppc64 doesn't, but our ppc64 variant has additional "stuff" to deal with
hotplug for example etc...

> >Also, aren't you missing a pci_dev_put() after pci_get_slot() ?
> probably. I will check.

Cheers,
Ben.

