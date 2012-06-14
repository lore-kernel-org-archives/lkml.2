Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2FNSYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:24:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56560 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2FNSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:24:54 -0400
Date: Thu, 14 Jun 2012 19:23:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: T Makphaibulchoke <tmac@hp.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kaloz@openwrt.org, nicolas.pitre@linaro.org, jj@chaosbits.net,
        matt.fleming@intel.com, lasse.collin@tukaani.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
	functions
Message-ID: <20120614182350.GB7628@n2100.arm.linux.org.uk>
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <4FD6B472.7040609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD6B472.7040609@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 08:16:02PM -0700, H. Peter Anvin wrote:
> On 06/11/2012 08:05 PM, T Makphaibulchoke wrote:
> > Cleaning up the file lib/decompress_unxz.c, moving all memory helper functions,
> > e.g. memmove, to a new common source file, lib/boot/mem.c.
> > 
> > In additon to including the decompressor, any architecture supporting the XZ
> > decompression needs to also include this new source file.
> > 
> > Also moving some other duplicated memory helper functions to this new source
> > file from the arm, s390, sh and x86 preboot environments.  All 4 architectures
> > build without error when using any compression.
> > 
> > Adding a new file lib/boot/mem.c, containing memory helper functions required
> > by different compression types.
> > 
> > Adding memcmp declaration workaround and removing the memmove and memcpy
> > defines workaround from arch/arm/boot/compressed/decompress.c
> > 
> > Removing the common functions, memmove, memcmp and memset, and adding the new
> > source file include to arch/arm/boot/compressed/string.c.
> > 
> > Removing the memcpy and memmove functions and adding the new source file
> > include to arch/s390/boot/compressed/misc.c.
> > 
> > Removing the memset function and adding the new source file include to
> > arch/sh/boot/compressed/misc.c
> > 
> > Removing the memset function from arch/x86/boot/compressed/misc.c and move
> > the memcpy function to the file arch/x86/boot/compressed/string.c
> > 
> > Adding the memcpy function and the new source file include to
> > arch/x86/boot/compressed/string.c
> > 
> 
> I can take this if Russell, Martin or Heiko, and Paul are willing to ack it.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

(Tested on OMAP4430SDP).
