Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab2JHKYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:24:23 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47827 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2JHKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:24:19 -0400
Date: Mon, 8 Oct 2012 11:24:13 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121008102413.GC2302@linaro.org>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121005084500.GI4625@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005084500.GI4625@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:45:00AM +0100, Russell King - ARM Linux wrote:
> On Mon, Oct 01, 2012 at 10:06:39AM -0600, Jason Gunthorpe wrote:
> > On Mon, Oct 01, 2012 at 04:39:53PM +0100, Dave Martin wrote:
> > > >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
> > > >   LOAD           0x008000 0xc0008000 0x00008000 0x372244 0x3a4310 RWE 0x8000
> > > 
> > > Not related directly to your patch, but I wonder why we don't we see
> > > separate r-x and rw- segments?
> > 
> > I think this is because the sections are not aligned when the
> > protections change, and the sections are not sorted by protection
> > type.
> 
> They aren't sorted by protection type, they're ordered according to what's
> required for the kernel - which is to have the init sections together as
> one complete block so that it can be freed, and to place all of the kernel
> text as close to the beginning of the image as possible.

Ah, right.

Partly this came from some side speculation about whether we could do
things like privileged read-only permissions on newer CPUs, for preventing
unintended or undesired writes to the kernel's code or read-only data.

There would be various things to solve in order to make that work, so I
guess there's no great urgency for it right now.

Cheers
---Dave
