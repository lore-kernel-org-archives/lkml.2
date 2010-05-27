Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0E0PVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:21:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab0E0PV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:21:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Thu, 27 May 2010 17:20:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005271702.45730.arnd@arndb.de> <4BFE8A12.2060606@tilera.com>
In-Reply-To: <4BFE8A12.2060606@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271720.37069.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX186WJWVpEs/Ah4i5UghNwA7nvun5c2qEcHFJN+
 8CkzarXU3GLLif4nGGf5ls6PukGv4UE2a6w9Y7MMRfMYqoafBm
 3aG1wKLlWx5t3Ynac453A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Chris Metcalf wrote:
> That turns out to be fairly easy:
> 
> #undef __SYSCALL
> #define __SYSCALL(nr, call) [nr] = (call),
> 
> #ifndef __tilegx__
> #define sys_fadvise64 sys32_fadvise64
> #define sys_fadvise64_64 sys32_fadvise64_64
> #define sys_readahead sys32_readahead
> #endif
> 
> void *sys_call_table[__NR_syscalls] = {
>         [0 ... __NR_syscalls-1] = sys_ni_syscall,
> #include <asm/unistd.h>
> };
> 

Ok. This does mean that you're no longer using a shared
version of the sys_call_table.c file but your own one, but
since the file so simple, that should not be a problem.

We can think about merging it when we have more architectures
that need a hack like this, which might never happen.

	Arnd
