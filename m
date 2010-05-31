Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0EaHAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:00:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:38179 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab0EaHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:00:48 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH -mm 0/3] remove useless ISA_DMA_THRESHOLD
Date: Mon, 31 May 2010 15:59:01 +0900
Message-Id: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 16:00:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes useless ISA_DMA_THRESHOLD:

- ISA_DMA_THRESHOLD is irrelevant to the majority of architectures but
  they have to define it.

- ISA_DMA_THRESHOLD definition is inconsistent on architectures; ISA
  DMA addressing restriction, DMA addressing restriction or something
  else.

- Everyone (except for SCSI) uses dma_mask instead of ancient
  ISA_DMA_THRESHOLD.

Only SCSI uses ISA_DMA_THRESHOLD for ancient drivers with non-zero
unchecked_isa_dma. We can safely remove ISA_DMA_THRESHOLD usage in
SCSI. So we can clean up ISA_DMA_THRESHOLD on the whole tree.

=
 arch/alpha/include/asm/scatterlist.h      |    2 --
 arch/avr32/include/asm/scatterlist.h      |    2 --
 arch/blackfin/include/asm/scatterlist.h   |    2 --
 arch/cris/include/asm/scatterlist.h       |    2 --
 arch/frv/include/asm/scatterlist.h        |    2 --
 arch/h8300/include/asm/scatterlist.h      |    2 --
 arch/ia64/include/asm/scatterlist.h       |    9 ---------
 arch/m32r/include/asm/scatterlist.h       |    2 --
 arch/m68k/include/asm/scatterlist.h       |    3 ---
 arch/microblaze/include/asm/scatterlist.h |    2 --
 arch/mips/include/asm/scatterlist.h       |    2 --
 arch/mn10300/include/asm/scatterlist.h    |    2 --
 arch/parisc/include/asm/scatterlist.h     |    1 -
 arch/powerpc/include/asm/scatterlist.h    |    3 ---
 arch/s390/include/asm/scatterlist.h       |    2 --
 arch/score/include/asm/scatterlist.h      |    2 --
 arch/sh/include/asm/scatterlist.h         |    2 --
 arch/sparc/include/asm/scatterlist.h      |    1 -
 arch/x86/include/asm/scatterlist.h        |    1 -
 arch/xtensa/include/asm/scatterlist.h     |    2 --
 drivers/scsi/aha1542.c                    |    9 ---------
 include/linux/blkdev.h                    |    2 +-
 22 files changed, 1 insertions(+), 56 deletions(-)



