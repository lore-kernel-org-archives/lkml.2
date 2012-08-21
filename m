Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2HULmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:42:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60706 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2HULms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:42:48 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH v2 0/2][powerpc] Export memory_limit via device tree 
To: linuxppc-dev@lists.ozlabs.org
Cc: mahesh@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2012 17:12:16 +0530
Message-ID: <20120821113815.29282.4000.stgit@suzukikp.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12082111-1396-0000-0000-000001BD9680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series exports the linux memory_limit set by
the mem= parameter via device-tree, so that kexec-tools
can limit the crash regions to the actual memory used by
the kernel.

Change since V1:

 * Added a patch to change the type of memory_limit to a
   fixed size(unsigned long long) from 'phys_addr_t' (which
   is 32bit on some ppc32 and 64 bit on ppc64 and some ppc32)

 * Rebased the patch to use recently fixed prom_update_property()
   which would add the property if it didn't exist.

---

Suzuki K. Poulose (2):
      [powerpc] Change memory_limit from phys_addr_t to unsigned long long
      [powerpc] Export memory limit via device tree


 arch/powerpc/include/asm/setup.h    |    2 +-
 arch/powerpc/kernel/fadump.c        |    3 +--
 arch/powerpc/kernel/machine_kexec.c |   14 +++++++++++++-
 arch/powerpc/kernel/prom.c          |    2 +-
 arch/powerpc/mm/mem.c               |    2 +-
 5 files changed, 17 insertions(+), 6 deletions(-)

-- 
Suzuki

