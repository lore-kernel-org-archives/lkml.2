Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1FVVcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:32:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:34522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab1FVVcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:32:06 -0400
Date: Wed, 22 Jun 2011 23:32:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: Simulating level triggered interrupts with edges
In-Reply-To: <20110622195008.GC19628@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.02.1106222233580.11814@ionos>
References: <20110622195008.GC19628@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Mark Brown wrote:

> I've run into a couple of cases recently where a system has had a device
> with a level triggered interrupt connected to an edge triggered
> interrupt controller.  Ignoring for the minute the hardware design
> concerns one might have this strikes me as something I'd expect the
> kernel to take a reasonable stab at handling in common code since it
> should be possible to have the core simply call the level triggered
> handler repeatedly until it returns IRQ_NONE when used with an edge
> based interrupt.  Obviously this leaves something to be desired but
> something like this seems to be the most sensible way to deal with such
> systems.
> 
> Is this supported by the current code?  I can't see any such support but
> that doesn't mean I'm not missing it.  If it is not supported and I'm
> not missing some much bigger problem with the idea can you make any
> suggestions about the least bad way to allow systems to do this?

No, we don't have support for this. Drivers should be careful about
such issues, but yes I can understand that we should think about
having support in the core code for such HW crap instead of cluttering
the drivers with such issues.

Though it's non-trivial. Think threaded interrupts, where we cannot
deal with that in handle_irq_edge(). I have no immediate idea how to
solve that at the core code, but feel free to have a stab.

Thanks,

	tglx



