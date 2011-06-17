Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1FQI65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:56146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
Subject: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
Date: Fri, 17 Jun 2011 10:38:25 +0200
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171038.25988.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enhances /dev/mem, so that read and write is possible
at any address. The patchset includes actual implementation for x86.

Petr Tesarik (10):
  Return EOF on out-of-bounds read from /dev/mem
  (un)xlate_dev_mem_ptr: use phys_addr_t for the @phys parameter
  x86: translate highmem /dev/mem pointers
  ia64: change xlate_dev_mem_ptr's argument to phys_addr_t
  valid_phys_addr_range: use phys_addr_t for the @addr parameter
  sh: change valid_phys_addr_range's @addr param to phys_addr_t
  arm: change valid_phys_addr_range's @addr param to phys_addr_t
  ia64: change valid_phys_addr_range's @addr param to phys_addr_t
  x86: provide arch-specific valid_phys_addr_range()
  Allow reading/writing all memory through /dev/mem

 arch/arm/include/asm/io.h       |    2 +-
 arch/arm/mm/mmap.c              |    2 +-
 arch/ia64/include/asm/io.h      |    2 +-
 arch/ia64/include/asm/uaccess.h |    2 +-
 arch/ia64/kernel/efi.c          |    2 +-
 arch/sh/include/asm/io.h        |    2 +-
 arch/sh/mm/mmap.c               |    2 +-
 arch/x86/include/asm/io.h       |   15 +++++++++++++--
 arch/x86/mm/ioremap.c           |   24 ++++++++++++++++++------
 drivers/char/mem.c              |   14 ++++++++++----
 10 files changed, 48 insertions(+), 19 deletions(-)

-- 
1.7.3.4

