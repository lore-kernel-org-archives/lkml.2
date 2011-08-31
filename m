Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1HaNez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:34:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1HaNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 05/35] Hexagon: Add syscalls
Date: Wed, 31 Aug 2011 15:34:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.195204162@codeaurora.org>
In-Reply-To: <20110830190800.195204162@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311534.51001.arnd@arndb.de>
X-Provags-ID: V02:K0:MuyFoCSPURAC9xGVR+Ij7qf/kB93cuxw4NareDnS0UK
 d14gaFrQrpTErBuLruFoS5yA+OLUUEtyMAiYRNOFqU1NGBDcKc
 kVODs3qYDvXZOVP1WqhA6EB2kAKRsIR6yBgNoSfYn7jW6FDy+J
 zgZBorjgEtc1aH5wv307jpjzWWpKlU2LuIIEjgS4Bzn9HF0cW1
 NeZtWz8w4EuV8FZKZPd7+Mfe/tbmELPeGGwySF6gTX13hjVgSb
 U06plcyzvmRjRwW/MzHzZuPYwCuJI1H73hCZFOtcnxmbYkg80e
 qFotxCZ+dcxv0gVA9jay3kMM8lZ/eIRV1LSwDy/stY7y0KOOLv
 O9FtF+8FjhA2xVaBbbdc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> +/*
> + * Many archictures support both sys_mmap and sys_mmap2, which use
> + * a common do_mmap2 function to do the work.  So long as we support
> + * only mmap2, we do it all in-line here.
> + */
> +asmlinkage int sys_mmap2(unsigned long addr, size_t len, unsigned long prot,
> +                        unsigned long flags, unsigned long fd,
> +                        unsigned long pgoff)
> +{

> +}
> +
> +/*  apparently this should only map on page boundaries  */
> +asmlinkage int sys_mmap(unsigned long addr, size_t len,
> +                       unsigned long prot, unsigned long flags,
> +                       unsigned long fd, off_t off)

The first comment doesn't make sense when you have the seconf function
as well. I thought I had commented that you should not provide either one
anyway and just use sys_mmap_pgoff() directly, like openrisc does.

It would probably be useful to change asm-generic/unistd.h to do that by
default, and change the architectures that still use mmap2 with
asm-generic/unistd.h to do a manual override.

	Arnd
