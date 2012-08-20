Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2HTSAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:00:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44671 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2HTSAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:00:40 -0400
Date: Mon, 20 Aug 2012 11:00:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
Message-ID: <20120820180037.GV4232@outflux.net>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1T1N2q-0001xm-5X@morero.ard.nu>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2012 at 09:11:11PM +0200, Ard Biesheuvel wrote:
> This patch adds support for the PROT_FINAL flag to
> the mmap() and mprotect() syscalls.
> 
> The PROT_FINAL flag indicates that the requested set
> of protection bits should be final, i.e., it shall
> not be allowed for a subsequent mprotect call to
> set protection bits that were not set already.
> 
> This is mainly intended for the dynamic linker,
> which sets up the address space on behalf of
> dynamic binaries. By using this flag, it can
> prevent exploited code from remapping read-only
> executable code or data sections read-write.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

This seems like a good idea to me. It would allow more than just the
loader to harden userspace allocations. It's a more direct version of
PaX's "MPROTECT" feature[1]. That feature hardens existing loaders,
but doesn't play nice with JITs (like Java), but this lets a loader
(or JIT) opt-in to the protection and have some direct control over it.

It seems like there needs to be a sensible way to detect that this flag is
available, though.

-Kees

[1] http://pax.grsecurity.net/docs/mprotect.txt

-- 
Kees Cook                                            @outflux.net
