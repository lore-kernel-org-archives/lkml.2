Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1CODlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:41:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1CODlR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 14 Mar 2011 23:41:17 -0400
Date: Mon, 14 Mar 2011 23:41:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        fengzhe.zhang@intel.com, ian.campbell@citrix.com
Subject: [GIT PULL] (xen) stable/e820 and stable/p2m-identity.v4.9.1 for
 2.6.39
Message-ID: <20110315034105.GA820@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D7EDFD5.0068,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull these two branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/p2m-identity.v4.9.1 stable/e820

Which are also located in #for-2.6.39/e820 as two merges for your convience
(no conflicts).

The #stable/p2m-identity.v4.9.1 is based off v2.6.38-rc2 (1bae4ce27c9c90344f23c65ea6966c50ffeae2f5).

The P2M identity code augments how Xen MMU deals with PFNs that point to physical
devices (PCI BARs, and such). When running under Xen before this patchset we would
not be able to effectively work with drivers that do not define VM_IO on their mmap paths
(InfiniBand, TTM, etc).  As such, this patchset allows the Xen MMU to parse the E820 and
figure out which PFNs should have the VM_IO flag automatically applied to them (or which
should have the VM_IO expunged).

while #stable/e820 is based off v2.6.38-rc5 (85e2efbb1db9a18d218006706d6e4fbeb0216213)

That branch contains two bug-fixes for parsing the E820 under some quite
specific conditions on Intel boxes. It fixes the intel-agp (and hence its user - the
i915 KMS driver) by now allocating the "Flush page" in the appropiate gap in I/O memory
(before the patch it ended allocating this "Flush page" in System RAM).

The diffstat:

 arch/x86/include/asm/xen/page.h |   47 +++++--
 arch/x86/xen/Kconfig            |    8 +
 arch/x86/xen/mmu.c              |   72 +++++++++-
 arch/x86/xen/p2m.c              |  324 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/setup.c            |   68 ++++++++-
 drivers/xen/balloon.c           |    2 +-
 6 files changed, 499 insertions(+), 22 deletions(-)


Konrad Rzeszutek Wilk (9):
      xen: Mark all initial reserved pages for the balloon as INVALID_P2M_ENTRY.
      xen/mmu: Add the notion of identity (1-1) mapping.
      xen/mmu: Set _PAGE_IOMAP if PFN is an identity PFN.
      xen/mmu: WARN_ON when racing to swap middle leaf.
      xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
      xen/debugfs: Add 'p2m' file for printing out the P2M layout.
      xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set.
      xen/m2p: No need to catch exceptions when we know that there is no RAM
      xen/e820: Don't mark balloon memory as E820_UNUSABLE when running as guest.

Stefano Stabellini (1):
      xen/m2p: Check whether the MFN has IDENTITY_FRAME bit set..

Zhang, Fengzhe (1):
      xen/setup: Inhibit resource API from using System RAM E820 gaps as PCI mem gaps.

