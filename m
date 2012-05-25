Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2EYGFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:05:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2EYGFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:05:52 -0400
Date: Fri, 25 May 2012 15:05:42 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Subject: Re: [PATCH] x86, realmode: 16-bit real-mode code support for relocs
 tool
Message-ID: <20120525060542.GA28472@kroah.com>
References: <1337924683-16189-1-git-send-email-jarkko.sakkinen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337924683-16189-1-git-send-email-jarkko.sakkinen@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 08:44:43AM +0300, Jarkko Sakkinen wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> A new option is added to the relocs tool called '--realmode'.
> This option causes the generation of 16-bit segment relocations
> and 32-bit linear relocations for the real-mode code. When
> the real-mode code is moved to the low-memory during kernel
> initialization, these relocation entries can be used to
> relocate the code properly.
> 
> In the assembly code 16-bit segment relocations must be relative
> to the 'real_mode_seg' absolute symbol. Linear relocations must be
> relative to a symbol prefixed with 'pa_'.
> 
> 16-bit segment relocation is used to load cs:ip in 16-bit code.
> Linear relocations are used in the 32-bit code for relocatable
> data references. They are declared in the linker script of the
> real-mode code.
> 
> The relocs tool is moved to arch/x86/tools/relocs.c, and added new
> target archscripts that can be used to build scripts needed building
> an architecture.  be compiled before building the arch/x86 tree.
> 
> [ hpa: accelerating this because it detects invalid absolute
>   relocations, a serious bug in binutils 2.22.52.0.x which currently
>   produces bad kernels. ]
> 
> [ jsakkine: pulled tools/include/tools/le_byteshift.h in order
>   to make this patch compile in 3.3 ]

Nope, your patch still doesn't apply, are you sure you sent me the
updated one?  It fails with:

patching file arch/x86/boot/compressed/Makefile
Hunk #1 succeeded at 40 (offset 1 line).
patching file arch/x86/boot/compressed/relocs.c
Hunk #1 FAILED at 1.
File arch/x86/boot/compressed/relocs.c is not empty after patch, as expected
1 out of 1 hunk FAILED -- rejects in file arch/x86/boot/compressed/relocs.c

when applying it to the 3.3-stable queue.

What did you generate it against?

thanks,

greg k-h
