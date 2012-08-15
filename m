Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2HONj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:39:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34677 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab2HONj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:39:56 -0400
Date: Wed, 15 Aug 2012 14:39:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
Message-ID: <20120815133923.GA12596@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
 <201208151330.02112.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151330.02112.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 15, 2012 at 02:30:01PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +/*
> > + * TCR flags.
> > + */
> > +#define TCR_TxSZ(x)		(((64 - (x)) << 16) | ((64 - (x)) << 0))
> > +#define TCR_IRGN_NC		((0 << 8) | (0 << 24))
> > +#define TCR_IRGN_WBWA		((1 << 8) | (1 << 24))
> > +#define TCR_IRGN_WT		((2 << 8) | (2 << 24))
> > +#define TCR_IRGN_WBnWA		((3 << 8) | (3 << 24))
> > +#define TCR_IRGN_MASK		((3 << 8) | (3 << 24))
> > +#define TCR_ORGN_NC		((0 << 10) | (0 << 26))
> > +#define TCR_ORGN_WBWA		((1 << 10) | (1 << 26))
> > +#define TCR_ORGN_WT		((2 << 10) | (2 << 26))
> > +#define TCR_ORGN_WBnWA		((3 << 10) | (3 << 26))
> > +#define TCR_ORGN_MASK		((3 << 10) | (3 << 26))
> > +#define TCR_SHARED		((3 << 12) | (3 << 28))
> > +#define TCR_TG0_64K		(1 << 14)
> > +#define TCR_TG1_64K		(1 << 30)
> > +#define TCR_IPS_40BIT		(2 << 32)
> > +#define TCR_ASID16		(1 << 36)
> > +
> 
> As a matter of coding style, I would much prefer tables like this to be
> written as
> 
> #define TCR_IRGN_MASK		0x0000000003000300
> #define TCR_IRGN_WBnWA		0x0000000003000300
> #define TCR_IRGN_WT		0x0000000002000200
> #define TCR_IRGN_WBWA		0x0000000001000100
> #define TCR_IRGN_NC		0x0000000000000000
> 
> #define TCR_ORGN_MASK		0x000000000c000c00
> #define TCR_ORGN_WBnWA		0x000000000c000c00
> #define TCR_ORGN_WT		0x0000000008000800
> #define TCR_ORGN_WBWA		0x0000000004000400
> #define TCR_ORGN_NC		0x0000000000000000
> 
> The advantage of this is that you can visually compare the bitmasks
> to a hex dump, and if you are suffering from endian-confused documentation
> authors, there is no ambiguity about which end of the word is bit zero.

That depends on the case, in some places it's more readable like this.
In the above case, I find it easier to compare against the documentation
which, for example, has groups of 2 bits at position 8 and 24 or 10 and
26 (for TTBR0 and TTBR1). The meaning of a group of 2 bits is described
separately as 0b00 (NC), 0b01(WBWA) etc. Same goes for the shareability
bits (12 and 28).

So I think at least for code writing it's less error-prone to write the
explicit bit position than a magic long hex.

-- 
Catalin
