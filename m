Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0E0PEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:04:54 -0400
Received: from king.tilera.com ([72.1.168.226]:37767 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0E0PEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:04:52 -0400
Message-ID: <4BFE8A12.2060606@tilera.com>
Date: Thu, 27 May 2010 11:04:50 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005271611.47963.arnd@arndb.de> <4BFE831A.8050002@tilera.com> <201005271702.45730.arnd@arndb.de>
In-Reply-To: <201005271702.45730.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 15:04:51.0154 (UTC) FILETIME=[F4CA2B20:01CAFDAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2010 11:02 AM, Arnd Bergmann wrote:
> Ok, I see. No objection to your kernel code then, we just need to
> figure out how to do that with the generic sys_call_table.
>   

That turns out to be fairly easy:

#undef __SYSCALL
#define __SYSCALL(nr, call) [nr] = (call),

#ifndef __tilegx__
#define sys_fadvise64 sys32_fadvise64
#define sys_fadvise64_64 sys32_fadvise64_64
#define sys_readahead sys32_readahead
#endif

void *sys_call_table[__NR_syscalls] = {
	[0 ... __NR_syscalls-1] = sys_ni_syscall,
#include <asm/unistd.h>
};


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


