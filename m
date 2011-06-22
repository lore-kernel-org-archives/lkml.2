Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab1FVTuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:50:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60244 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758014Ab1FVTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:50:11 -0400
Date: Wed, 22 Jun 2011 20:50:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Simulating level triggered interrupts with edges
Message-ID: <20110622195008.GC19628@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've run into a couple of cases recently where a system has had a device
with a level triggered interrupt connected to an edge triggered
interrupt controller.  Ignoring for the minute the hardware design
concerns one might have this strikes me as something I'd expect the
kernel to take a reasonable stab at handling in common code since it
should be possible to have the core simply call the level triggered
handler repeatedly until it returns IRQ_NONE when used with an edge
based interrupt.  Obviously this leaves something to be desired but
something like this seems to be the most sensible way to deal with such
systems.

Is this supported by the current code?  I can't see any such support but
that doesn't mean I'm not missing it.  If it is not supported and I'm
not missing some much bigger problem with the idea can you make any
suggestions about the least bad way to allow systems to do this?
