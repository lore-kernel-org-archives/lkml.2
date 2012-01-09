Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2AIHrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:47:36 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:37543 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2AIHre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:47:34 -0500
Date: Mon, 9 Jan 2012 08:47:28 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for 3.3
Message-ID: <20120109084728.612edbda@de.ibm.com>
In-Reply-To: <CA+55aFy1F6vrLYZ-S+-jq0AiSVOQ15NoFosW3GmMbyKzYyjEqQ@mail.gmail.com>
References: <20120107200122.5a78669d@de.ibm.com>
	<CA+55aFy1F6vrLYZ-S+-jq0AiSVOQ15NoFosW3GmMbyKzYyjEqQ@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12010907-1948-0000-0000-0000009505EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012 15:17:38 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Jan 7, 2012 at 11:01 AM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> >
> > please pull from 'for-linus' branch of
> >
> >        git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
> >
> > to receive the following updates:
> 
> Where did the diffstat go? I'm pretty sure you usually send it, and I
> really want diffstat (in addition to the shortlog) to verify pull
> requests..

>From the merge window pulls I usually remove the patch itself. Seems like
I removed the diffstat as well. Once more with feeling:

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Carsten Otte (1):
      [S390] disable MACHINE_IS_VM check for pfault

Christian Borntraeger (1):
      [S390] kvm: fix sleeping function ... at mm/page_alloc.c:2260

Heiko Carsten (1):
      [S390] sysctl: get rid of dead declaration

Heiko Carstens (9):
      [S390] irq: fix accounting of external call/emergency signal
      [S390] topology: get rid of ifdefs
      [S390] qdio: fix qdio_allocate_aob() declaration
      [S390] topology: cleanup z10 topology handling
      [S390] topology: increase poll frequency if change is anticipated
      [S390] Remove Kerntypes leftovers
      [S390] ipc: call generic sys_ipc demultiplexer
      [S390] Enable exception traces by default
      [S390] disassembler: mark exception causing instructions

Holger Dengler (2):
      [S390] zcrypt: Rework length parameter checking.
      [S390] zcrypt: Fix error return codes.

Jan Glauber (1):
      [S390] make arch/s390 subdirectories depend on config option

Martin Schwidefsky (6):
      [S390] add support for physical memory > 4TB
      [S390] kvm: move cmf host id constant out of lowcore
      [S390] entry[64].S improvements
      [S390] cleanup trap handling
      [S390] outstanding interrupts vs. smp_send_stop
      [S390] return address of compat signals

Michael Holzheu (6):
      [S390] Check for NULL termination in command line setup
      [S390] Rework create_mem_hole() function
      [S390] Remove useless newline in reserve_kdump_bootmem()
      [S390] kernel: Fix smp_switch_to_ipl_cpu() stack frame setup
      [S390] Add VMCOREINFO_SYMBOL(high_memory) to vmcoreinfo
      [S390] Add s390x description to Documentation/kdump/kdump.txt

Stefan Haberland (2):
      [S390] dasd: add sanity check to detect path connection error
      [S390] dasd: fix fixpoint divide exception in define_extent

Stefan Weinhuber (1):
      [S390] dasd: fix expiration handling for recovery requests

Steffen Maier (1):
      [S390] qdio: fix kernel panic for zfcp 31-bit

 Documentation/dontdiff              |    1 -
 Documentation/kdump/kdump.txt       |   35 +-
 Documentation/s390/Debugging390.txt |   34 --
 arch/s390/Kbuild                    |   13 +-
 arch/s390/Kconfig                   |   11 +-
 arch/s390/Makefile                  |    1 -
 arch/s390/boot/Makefile             |    2 +-
 arch/s390/include/asm/kdebug.h      |    2 +-
 arch/s390/include/asm/lowcore.h     |  142 +++---
 arch/s390/include/asm/pgtable.h     |   23 +-
 arch/s390/include/asm/processor.h   |    2 -
 arch/s390/include/asm/ptrace.h      |    3 +-
 arch/s390/include/asm/qdio.h        |    5 +-
 arch/s390/include/asm/sigp.h        |    1 +
 arch/s390/include/asm/smp.h         |    1 -
 arch/s390/include/asm/sparsemem.h   |    4 +-
 arch/s390/include/asm/syscall.h     |    2 +-
 arch/s390/include/asm/system.h      |    2 -
 arch/s390/include/asm/topology.h    |   40 ++-
 arch/s390/include/asm/unistd.h      |    1 +
 arch/s390/kernel/Makefile           |    3 +-
 arch/s390/kernel/asm-offsets.c      |    8 +-
 arch/s390/kernel/base.S             |   16 +-
 arch/s390/kernel/compat_linux.c     |    3 -
 arch/s390/kernel/compat_signal.c    |   12 +-
 arch/s390/kernel/dis.c              |    9 +-
 arch/s390/kernel/early.c            |   20 +-
 arch/s390/kernel/entry.S            | 1103 +++++++++++++++--------------------
 arch/s390/kernel/entry.h            |   10 +-
 arch/s390/kernel/entry64.S          |  976 ++++++++++++++-----------------
 arch/s390/kernel/head.S             |    4 +-
 arch/s390/kernel/machine_kexec.c    |    1 +
 arch/s390/kernel/mem_detect.c       |  122 +++--
 arch/s390/kernel/reipl64.S          |    4 +-
 arch/s390/kernel/setup.c            |   69 ++-
 arch/s390/kernel/signal.c           |   20 +-
 arch/s390/kernel/smp.c              |  173 +++----
 arch/s390/kernel/sys_s390.c         |   76 +--
 arch/s390/kernel/topology.c         |  275 ++++++---
 arch/s390/kernel/traps.c            |  170 ++----
 arch/s390/mm/fault.c                |  107 ++--
 arch/s390/mm/init.c                 |   16 +-
 arch/s390/mm/pgtable.c              |   14 +-
 drivers/s390/block/dasd_3990_erp.c  |    4 +-
 drivers/s390/block/dasd_alias.c     |   10 +
 drivers/s390/block/dasd_eckd.c      |  411 ++++++++++----
 drivers/s390/cio/qdio_setup.c       |   10 +-
 drivers/s390/crypto/zcrypt_pcixcc.c |   32 +-
 drivers/s390/net/qeth_core_main.c   |    2 +-
 49 files changed, 1986 insertions(+), 2019 deletions(-)

