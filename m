Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2GWR6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:58:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43164 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab2GWR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:58:50 -0400
Date: Mon, 23 Jul 2012 18:58:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120723175830.GA6027@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <4FF75986.8010706@wwwdotorg.org>
 <20120708091819.GA3845@arm.com>
 <500D8E5C.9020206@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D8E5C.9020206@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 06:48:12PM +0100, Stephen Warren wrote:
> On 07/08/2012 03:18 AM, Catalin Marinas wrote:
> > On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> >> On 07/06/2012 03:05 PM, Catalin Marinas wrote:
> >>> The patch adds the kernel booting and the initial setup code.
> >>> Documentation/aarch64/booting.txt describes the booting protocol on the
> >>> AArch64 Linux kernel. This is subject to change following the work on
> >>> boot standardisation, ACPI.
> ...
> >>> +4. Call the kernel image
> >>> +------------------------
> >>> +
> >>> +Requirement: MANDATORY
> >>> +
> >>> +The decompressed kernel image contains a 32-byte header as follows:
> >>> +
> >>> +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> >>> +  u32 res0	= 0;		/* reserved */
> >>> +  u64 text_offset;		/* Image load offset */
> >>> +  u64 res1	= 0;		/* reserved */
> >>> +  u64 res2	= 0;		/* reserved */
> >>> +
> >>> +The image must be placed at the specified offset (currently 0x80000)
> >>> +from the start of the system RAM (aligned to 2MB) and called there.
> >>
> >> Is "0x80000" meant to have an extra "0"; 0x80000 isn't aligned to 2MB
> >> unless I'm really missing too much sleep today.
> >  
> > The value is correct, it wasn't meant to be aligned to 2MB. Why would
> > that be? It's just an offset from the start of the RAM, which must
> > indeed be 2MB aligned (PHYS_OFFSET).
> 
> Oh, I see, it's the start of SDRAM that's aligned to 2MB, not the offset
> from the start of SDRAM that needs to be aligned to 2MB. The wording
> seems slightly unclear to me. Perhaps just drop the mention of alignment
> at all, or add "which is" before "aligned to 2MB"?

I'll probably just another sentence to make it clear that it refers to
the start of the RAM.

Thanks.

-- 
Catalin
