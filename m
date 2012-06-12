Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2FLDRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:17:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37178 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2FLDRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:17:40 -0400
Message-ID: <4FD6B472.7040609@zytor.com>
Date: Mon, 11 Jun 2012 20:16:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: T Makphaibulchoke <tmac@hp.com>
CC: linux@arm.linux.org.uk, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kaloz@openwrt.org,
        nicolas.pitre@linaro.org, jj@chaosbits.net, matt.fleming@intel.com,
        lasse.collin@tukaani.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
References: <1339470307-28223-1-git-send-email-tmac@hp.com>
In-Reply-To: <1339470307-28223-1-git-send-email-tmac@hp.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 08:05 PM, T Makphaibulchoke wrote:
> Cleaning up the file lib/decompress_unxz.c, moving all memory helper functions,
> e.g. memmove, to a new common source file, lib/boot/mem.c.
> 
> In additon to including the decompressor, any architecture supporting the XZ
> decompression needs to also include this new source file.
> 
> Also moving some other duplicated memory helper functions to this new source
> file from the arm, s390, sh and x86 preboot environments.  All 4 architectures
> build without error when using any compression.
> 
> Adding a new file lib/boot/mem.c, containing memory helper functions required
> by different compression types.
> 
> Adding memcmp declaration workaround and removing the memmove and memcpy
> defines workaround from arch/arm/boot/compressed/decompress.c
> 
> Removing the common functions, memmove, memcmp and memset, and adding the new
> source file include to arch/arm/boot/compressed/string.c.
> 
> Removing the memcpy and memmove functions and adding the new source file
> include to arch/s390/boot/compressed/misc.c.
> 
> Removing the memset function and adding the new source file include to
> arch/sh/boot/compressed/misc.c
> 
> Removing the memset function from arch/x86/boot/compressed/misc.c and move
> the memcpy function to the file arch/x86/boot/compressed/string.c
> 
> Adding the memcpy function and the new source file include to
> arch/x86/boot/compressed/string.c
> 

I can take this if Russell, Martin or Heiko, and Paul are willing to ack it.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

