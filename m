Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2JEIpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:45:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46539 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2JEIpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:45:20 -0400
Date: Fri, 5 Oct 2012 09:45:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
	program headers
Message-ID: <20121005084500.GI4625@n2100.arm.linux.org.uk>
References: <20120930232116.GC30637@obsidianresearch.com> <20121001153952.GB2100@linaro.org> <20121001160639.GA31620@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001160639.GA31620@obsidianresearch.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:06:39AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 01, 2012 at 04:39:53PM +0100, Dave Martin wrote:
> > >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
> > >   LOAD           0x008000 0xc0008000 0x00008000 0x372244 0x3a4310 RWE 0x8000
> > 
> > Not related directly to your patch, but I wonder why we don't we see
> > separate r-x and rw- segments?
> 
> I think this is because the sections are not aligned when the
> protections change, and the sections are not sorted by protection
> type.

They aren't sorted by protection type, they're ordered according to what's
required for the kernel - which is to have the init sections together as
one complete block so that it can be freed, and to place all of the kernel
text as close to the beginning of the image as possible.
