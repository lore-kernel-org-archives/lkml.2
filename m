Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2BHN0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:26:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53189 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2BHN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:26:35 -0500
Date: Wed, 8 Feb 2012 13:26:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: CMA on arm from zero address
Message-ID: <20120208132622.GL889@n2100.arm.linux.org.uk>
References: <4F326A4E.1030106@monstr.eu> <20120208130807.GJ889@n2100.arm.linux.org.uk> <4F3276D6.3060507@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3276D6.3060507@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 02:21:26PM +0100, Michal Simek wrote:
> First of all I have found how to do it (by CONFIG_PHYS_OFFSET) so the
> problem is in QEMU.

So you're basically not telling the kernel about the first 32MB of memory.

> Currently experimenting how to convince CMA to allocate that memory for
> my purpose.

Which means it won't be part of the kernels normal memory map, and so
won't be in the page pool.  So CMA won't be able to help.

Instead, just ignore the first 32MB of RAM, and map it like any other
peripheral to gain access to it.  You might need to use ioremap_wc()
to avoid treating the memory as a 'device type' in ARMv6+.
