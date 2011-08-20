Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1HTTTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:19:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39447 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1HTTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:19:01 -0400
Message-ID: <4E5008A1.8070105@landley.net>
Date: Sat, 20 Aug 2011 14:18:57 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, gerg@uclinux.org
Subject: m68k with mmu doesn't compile after 66d857b08b8c3ed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k build in 3.0 dies with this:

  CC      arch/m68k/kernel/dma.o
In file included from arch/m68k/kernel/dma.c:4:
arch/m68k/kernel/dma_no.c: In function 'dma_sync_single_for_cpu':
arch/m68k/kernel/dma_no.c:44: error: implicit declaration of function
'flush_dcache_range'
make[1]: *** [arch/m68k/kernel/dma.o] Error 1
make: *** [arch/m68k/kernel] Error 2

That file includes <asm/cacheflush.h>, which for m68k is:

#ifdef __uClinux__
#include "cacheflush_no.h"
#else
#include "cacheflush_mm.h"
#endif

The nommu header (cacheflush_no.h) does #define flush_dcache_range(),
but the clacheflush_mm.h version does not.  I.E. you can only currently
build m68k for Coldfire, you can no longer build it for an actual m68k.

(A git log of Linus' tree shows cacheflush_mm.h hasn't been touched
since 2010, and I pulled earlier today.)

Rob
