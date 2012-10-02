Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2JBPlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:41:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59837 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625Ab2JBPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:41:13 -0400
Date: Tue, 2 Oct 2012 16:39:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 10/36] AArch64: MMU definitions
Message-ID: <20121002153939.GH25708@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-11-git-send-email-catalin.marinas@arm.com>
 <506A3898.7000804@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506A3898.7000804@jonmasters.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:43:04AM +0100, Jon Masters wrote:
> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> 
> > +/*
> > + * PAGE_OFFSET - the virtual address of the start of the kernel image.
> > + * VA_BITS - the maximum number of bits for virtual addresses.
> > + * TASK_SIZE - the maximum size of a user space task.
> > + * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
> > + * The module space lives between the addresses given by TASK_SIZE
> > + * and PAGE_OFFSET - it must be within 128MB of the kernel text.
> > + */
> > +#define PAGE_OFFSET		UL(0xffffffc000000000)
> > +#define MODULES_END		(PAGE_OFFSET)
> > +#define MODULES_VADDR		(MODULES_END - SZ_64M)
> > +#define VA_BITS			(39)
> > +#define TASK_SIZE_64		(UL(1) << VA_BITS)
> 
> Pedantic nit pick. Shouldn't that "it must be within 128MB of the kernel
> text" be "within 128MB of the *end* of the kernel text"? The point being
> that on AArch64 unconditional branches are encoded as imm26+1 (27 bits)
> and so you're going with -64MB to ensure that you're within the range.

I read it to be within 128MB of any part of the kernel text but I can
change it to "end of" if that's clearer.

-- 
Catalin
