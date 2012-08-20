Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2HTVsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:48:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HTVsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120820180037.GV4232@outflux.net>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
Date: Mon, 20 Aug 2012 23:48:37 +0200
Message-ID: <CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems like a good idea to me. It would allow more than just the
> loader to harden userspace allocations. It's a more direct version of
> PaX's "MPROTECT" feature[1]. That feature hardens existing loaders,
> but doesn't play nice with JITs (like Java), but this lets a loader
> (or JIT) opt-in to the protection and have some direct control over it.
>

If desired, additional restrictions can be imposed by using the
security framework, e.g,, disallow non-final r-x mappings.

> It seems like there needs to be a sensible way to detect that this flag is
> available, though.
>

I am open for suggestions to address this. Our particular
implementation of the loader (on an embedded system) tries to set it
on the first mmap invocation, and stops trying if it fails. Not the
most elegant approach, I know ...

-- 
Ard.


> -Kees
>
> [1] http://pax.grsecurity.net/docs/mprotect.txt
>
> --
> Kees Cook                                            @outflux.net
