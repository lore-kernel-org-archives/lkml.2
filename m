Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1FTStd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:49:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51917 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1FTSt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:49:28 -0400
Date: Mon, 20 Jun 2011 19:48:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Nicolas Pitre <nico@fluxnic.net>, gregkh@suse.de,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
	the packed attribute
Message-ID: <20110620184849.GI26089@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home> <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 01:35:35PM -0400, Alan Stern wrote:
> According to Arnd, any remaining possible issues will be addressed by
> changing the implementation of readl/writel on ARM.  It doesn't look as
> though the ehci files need anything else done.

I'm not about to change their implementation because they've proven
themselves over the last 10 years to be perfectly fine, and changing
them has a habbit of causing GCC to play less optimally than it should
do.

I've seen drivers where GCC reloads the base address from the driver
private data structure each time a register access is performed, rather
than caching the base address in a register.  I've seen it issuing
separate add instructions and using a zero pre-index load/store.  The
existing way is the only way I've found to get GCC to come anywhere
close to producing "optimal" code for the IO accessors.

If it is the case that these structures do not require packing to get
their desired layout, then they don't require packing, and the packed
attribute should be dropped.
