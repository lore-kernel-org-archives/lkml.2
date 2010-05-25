Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab0EYPNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:13:10 -0400
Received: from king.tilera.com ([72.1.168.226]:44273 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab0EYPNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:13:08 -0400
Message-ID: <4BFBE8FF.6080208@tilera.com>
Date: Tue, 25 May 2010 11:13:03 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005242053.25594.arnd@arndb.de> <4BFBD68C.9060405@tilera.com> <201005251703.11613.arnd@arndb.de>
In-Reply-To: <201005251703.11613.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2010 15:13:05.0592 (UTC) FILETIME=[C6ABEB80:01CAFC1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2010 11:03 AM, Arnd Bergmann wrote:
> I would keep allocating from the bottom. For now, maybe we should just
> reserve 16 arch specific syscall numbers starting at 244, and add
>
> #define __NR_tile_cmpxchg_baddr (__NR_arch_specific_syscall + 0)
> #define __NR_tile_raise_fpe	(__NR_arch_specific_syscall + 1)
> #define __NR_tile_flush_cache	(__NR_arch_specific_syscall + 2)
>
> to your own unistd.h.
>   

OK.

>  The idea was to only have them around as a transitional helper for
> new architectures while getting merged, but nothing should ever
> use these in production.
>   

Perhaps the best strategy for Tile for now is to enable the transitional
helpers, and then when glibc no longer requires any of those syscalls,
we can remove them from the kernel.  If this happens in the relatively
short term (e.g. before our 3.0 release later this year) all the better,
but for now we can separate this into a first change that preserves most
of the compatibility syscalls, and work towards remove them in a later
release.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


