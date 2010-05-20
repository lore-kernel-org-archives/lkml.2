Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0ETDUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:20:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:48852 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0ETDUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:20:47 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: davem@davemloft.net, dwmw2@infradead.org
Subject: [PATCH -mm 0/6] ARCH_KMALLOC_MINALIGN fixes
Date: Thu, 20 May 2010 12:21:37 +0900
Message-Id: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 May 2010 12:20:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As DMA-API-HOWTO says, kmalloc'ed buffer must be DMA-safe. Drivers and
subsystems depend on it.

So architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN: the kmalloc'ed buffer doesn't share a cache
with the others. Otherwise, we hit memory corruption due to DMA.

I had a quick look at all the architectures. Seems that some
architectures that need to set ARCH_KMALLOC_MINALIGN don't do.

=
 arch/blackfin/include/asm/cache.h |    2 ++
 arch/frv/include/asm/cache.h      |    2 ++
 arch/m68k/include/asm/cache.h     |    2 ++
 arch/mn10300/include/asm/cache.h  |    2 ++
 arch/parisc/include/asm/cache.h   |    2 ++
 arch/xtensa/include/asm/cache.h   |    1 +
 6 files changed, 11 insertions(+), 0 deletions(-)
