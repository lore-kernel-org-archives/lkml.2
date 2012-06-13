Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2FMJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:33:04 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:37272 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2FMJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:33:01 -0400
Date: Wed, 13 Jun 2012 11:32:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: T Makphaibulchoke <tmac@hp.com>, linux@arm.linux.org.uk,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kaloz@openwrt.org, nicolas.pitre@linaro.org, jj@chaosbits.net,
        matt.fleming@intel.com, lasse.collin@tukaani.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
Message-ID: <20120613113223.0fc3c490@de.ibm.com>
In-Reply-To: <4FD6B472.7040609@zytor.com>
References: <1339470307-28223-1-git-send-email-tmac@hp.com>
	<4FD6B472.7040609@zytor.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12061309-6892-0000-0000-0000021D0B10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 20:16:02 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

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

Just tested kernel compression with all five compression algorithms,
works fine for s390.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

