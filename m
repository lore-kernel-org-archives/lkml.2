Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2JQOPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab2JQOPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:24 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/10] UAPI: Fixes
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 15:15:21 +0100
Message-ID: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here are some UAPI fixes for you.  They can be found in git at:

	git://git.infradead.org/users/dhowells/linux-headers.git

on the uapi-fixes branch at the uapi-fixes-20121017 tag.

They do a number of things:

 (1) Import a patch from Catalin Marinas to extend the generic-y in Kbuild
     facility to uapi directories.

 (2) Make arch/tile's ucontext.h file use (1) and remove the header-y line
     from the kernel internal side of things.

 (3) Remove some now-empty conditional bits from include/linux/Kbuild.  The
     contents got moved to the UAPI side of things along with new
     conditionals.

 (4) Deal with now-empty files:

     (a) Empty Kbuild files under include/ get removed.

     (b) Empty Kbuild files under arch/ get comments to hold them as they are
     	 likely to end up with generic-y or genhdr-y lines.  Deleting them
     	 appears to work if we want to go that route.

     (c) Put a comment into uapi/asm-generic/kvm_para.h to prevent the patch
     	 program from deleting that, and made the arches with empty kvm_para.h
     	 uapi files use that instead of having their own files.

     (d) Put comments into four other empty uapi/ headers to prevent the patch
     	 program from deleting them.

A question: Is this the right way to deal with the now-empty Kbuild files?

The ones under include/ are unlikely to be used - even for generated files, I
think - so getting rid of them is probably okay.  Once all the bits are in, we
can probably remove all the Kbuild files under include/ that aren't also under
include/uapi/.

The ones under arch/ are more of an issue because of the potential for
generic-y and genhdr-y.

David
---
Catalin Marinas (1):
      uapi: Allow automatic generation of uapi/asm/ header files

David Howells (9):
      UAPI: Make arch/sparc/include/uapi/asm/sigcontext.h non-empty
      UAPI: Make arch/sh/include/uapi/asm/hw_breakpoint.h non-empty
      UAPI: Make arch/mn10300/include/uapi/asm/setup.h non-empty
      UAPI: Put a comment into uapi/asm-generic/kvm_para.h and use it from arches
      UAPI: The tile arch uses the generic ucontext.h file
      UAPI: Place comments in empty arch Kbuilds to make them non-empty
      UAPI: Remove empty non-UAPI Kbuild files
      UAPI: Remove empty conditionals from include/linux/Kbuild
      UAPI: Make uapi/linux/irqnr.h non-empty


 Makefile                                 |    4 +++-
 arch/ia64/include/uapi/asm/Kbuild        |    2 ++
 arch/ia64/include/uapi/asm/kvm_para.h    |    0 
 arch/mips/include/asm/Kbuild             |    1 +
 arch/mn10300/include/uapi/asm/setup.h    |    4 ++++
 arch/s390/include/uapi/asm/Kbuild        |    2 ++
 arch/s390/include/uapi/asm/kvm_para.h    |    0 
 arch/sh/include/uapi/asm/hw_breakpoint.h |    4 ++++
 arch/sparc/include/uapi/asm/sigcontext.h |    4 ++++
 arch/tile/include/arch/Kbuild            |    1 +
 arch/tile/include/asm/Kbuild             |    3 ---
 arch/tile/include/uapi/asm/Kbuild        |    3 +++
 include/Kbuild                           |    4 ----
 include/asm-generic/Kbuild               |    0 
 include/drm/Kbuild                       |    0 
 include/linux/Kbuild                     |   26 --------------------------
 include/linux/byteorder/Kbuild           |    0 
 include/linux/caif/Kbuild                |    0 
 include/linux/can/Kbuild                 |    0 
 include/linux/isdn/Kbuild                |    0 
 include/linux/mmc/Kbuild                 |    0 
 include/linux/netfilter/Kbuild           |    1 -
 include/linux/netfilter/ipset/Kbuild     |    0 
 include/linux/netfilter_arp/Kbuild       |    0 
 include/linux/netfilter_bridge/Kbuild    |    0 
 include/linux/netfilter_ipv4/Kbuild      |    0 
 include/linux/netfilter_ipv6/Kbuild      |    0 
 include/linux/nfsd/Kbuild                |    0 
 include/linux/spi/Kbuild                 |    0 
 include/linux/sunrpc/Kbuild              |    0 
 include/linux/tc_act/Kbuild              |    0 
 include/linux/tc_ematch/Kbuild           |    0 
 include/linux/wimax/Kbuild               |    0 
 include/mtd/Kbuild                       |    0 
 include/uapi/asm-generic/kvm_para.h      |    4 ++++
 include/uapi/linux/irqnr.h               |    4 ++++
 include/xen/Kbuild                       |    0 
 scripts/Makefile.asm-generic             |    2 +-
 38 files changed, 33 insertions(+), 36 deletions(-)
 delete mode 100644 arch/ia64/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/s390/include/uapi/asm/kvm_para.h
 delete mode 100644 include/asm-generic/Kbuild
 delete mode 100644 include/drm/Kbuild
 delete mode 100644 include/linux/byteorder/Kbuild
 delete mode 100644 include/linux/caif/Kbuild
 delete mode 100644 include/linux/can/Kbuild
 delete mode 100644 include/linux/isdn/Kbuild
 delete mode 100644 include/linux/mmc/Kbuild
 delete mode 100644 include/linux/netfilter/Kbuild
 delete mode 100644 include/linux/netfilter/ipset/Kbuild
 delete mode 100644 include/linux/netfilter_arp/Kbuild
 delete mode 100644 include/linux/netfilter_bridge/Kbuild
 delete mode 100644 include/linux/netfilter_ipv4/Kbuild
 delete mode 100644 include/linux/netfilter_ipv6/Kbuild
 delete mode 100644 include/linux/nfsd/Kbuild
 delete mode 100644 include/linux/spi/Kbuild
 delete mode 100644 include/linux/sunrpc/Kbuild
 delete mode 100644 include/linux/tc_act/Kbuild
 delete mode 100644 include/linux/tc_ematch/Kbuild
 delete mode 100644 include/linux/wimax/Kbuild
 delete mode 100644 include/mtd/Kbuild
 delete mode 100644 include/xen/Kbuild

