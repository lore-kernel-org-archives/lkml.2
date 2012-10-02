Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2JBSNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:13:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2JBSNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:13:06 -0400
Date: Tue, 02 Oct 2012 14:13:03 -0400 (EDT)
Message-Id: <20121002.141303.1724289885159896055.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Largely this is simply adding support for the Niagara 4 cpu.

Major areas are perf events (chip now supports 4 counters and
can monitor any event on each counter), crypto (opcodes
are availble for sha1, sha256, sha512, md5, crc32c, AES, DES,
CAMELLIA, and Kasumi although the last is unsupported since
we lack a generic crypto layer Kasumi implementation), and.
an optimized memcpy.

Finally some cleanups by Peter Senna Tschudin.

Please pull, thanks a lot.

The following changes since commit 6dab7ede9390d4d937cb89feca932e4fd575d2da:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-08-18 16:20:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 42a4172b6ebb4a419085c6caee7c135e51cae5ea:

  sparc64: Fix trailing whitespace in NG4 memcpy. (2012-09-28 13:08:22 -0700)

----------------------------------------------------------------
David S. Miller (45):
      sparc64: Add detection for features new in SPARC-T4.
      sparc64: Add hypervisor interfaces for SPARC-T4 perf counter access.
      sparc64: Add 'reg_num' argument to pcr_ops methods.
      sparc64: Abstract away PIC register accesses.
      sparc64: Abstract away the NMI PIC counter computation.
      sparc64: Abstract away the %pcr values used to enable/disable NMI
      sparc64: Add PCR ops for SPARC-T4.
      sparc64: Add perf_event abstractions for orthogonal PMUs.
      sparc64: Allow max hw perf events to be variable.
      sparc64: Abstract PMC read/write behind sparc_pmu.
      sparc64: Specify user and supervisor trace PCR bits in sparc_pmu.
      sparc64: Prepare perf event layer for handling multiple PCR registers.
      sparc64: Rework sparc_pmu_enable() so that the side effects are clearer.
      sparc64: Make sparc_pmu_{enable,disable}_event() multi-pcr aware.
      sparc64: Support perf event encoding for multi-PCR PMUs.
      sparc64: Add SPARC-T4 perf event support.
      sparc64: Update generic comments in perf event code to match reality.
      sparc64: Add SHA1 driver making use of the 'sha1' instruction.
      sparc64: Add SHA224/SHA256 driver making use of the 'sha256' instruction.
      sparc64: Add SHA384/SHA512 driver making use of the 'sha512' instruction.
      sparc64: Add MD5 driver making use of the 'md5' instruction.
      sparc64: Add AES driver making use of the new aes opcodes.
      sparc64: Add CRC32C driver making use of the new crc32c opcode.
      sparc64: Add DES driver making use of the new des opcodes.
      sparc64: Fix spelling of CAMELLIA in CFR macro name and comment.
      sparc64: Add CAMELLIA driver making use of the new camellia opcodes.
      sparc64: Use fsrc2 instead of fsrc1 in sparc64 hash crypto drivers.
      sparc64: Move AES driver over to a methods based implementation.
      sparc64: Add ctr mode support to AES driver.
      sparc64: Unroll ECB encryption loops in AES driver.
      sparc64: Unroll ECB decryption loops in AES driver.
      sparc64: Unroll CTR crypt loops in AES driver.
      sparc64: Avoid code duplication in crypto assembler.
      sparc64: Fix bugs in unrolled 256-bit loops.
      sparc64: Support 2GB and 16GB page sizes for kernel linear mappings.
      sparc64: Probe cpu page size support more portably.
      sparc64: Use cpu_pgsz_mask for linear kernel mapping config.
      sparc64: Adjust crypto priorities.
      sparc64: Add missing pr_fmt define to crypto opcode drivers.
      sparc64: Add auto-loading mechanism to crypto-opcode drivers.
      sparc64: Fix IV handling bug in des_sparc64_cbc_decrypt
      sparc64: Fix function argument comment in camellia_sparc64_key_expand asm.
      sparc64: Add SPARC-T4 optimized memcpy.
      sparc64: Fix comment type in NG4 copy from user.
      sparc64: Fix trailing whitespace in NG4 memcpy.

Peter Senna Tschudin (2):
      arch/sparc/kernel/pci_sun4v.c: removes unnecessary semicolon
      drivers/sbus/char: removes unnecessary semicolon

 arch/sparc/Kbuild                   |    1 +
 arch/sparc/crypto/Makefile          |   25 ++
 arch/sparc/crypto/aes_asm.S         | 1535 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/crypto/aes_glue.c        |  477 ++++++++++++++++++++++++
 arch/sparc/crypto/camellia_asm.S    |  563 +++++++++++++++++++++++++++++
 arch/sparc/crypto/camellia_glue.c   |  322 +++++++++++++++++
 arch/sparc/crypto/crc32c_asm.S      |   20 ++
 arch/sparc/crypto/crc32c_glue.c     |  179 +++++++++
 arch/sparc/crypto/crop_devid.c      |   14 +
 arch/sparc/crypto/des_asm.S         |  418 +++++++++++++++++++++
 arch/sparc/crypto/des_glue.c        |  529 +++++++++++++++++++++++++++
 arch/sparc/crypto/md5_asm.S         |   70 ++++
 arch/sparc/crypto/md5_glue.c        |  188 ++++++++++
 arch/sparc/crypto/opcodes.h         |   99 +++++
 arch/sparc/crypto/sha1_asm.S        |   72 ++++
 arch/sparc/crypto/sha1_glue.c       |  183 ++++++++++
 arch/sparc/crypto/sha256_asm.S      |   78 ++++
 arch/sparc/crypto/sha256_glue.c     |  241 +++++++++++++
 arch/sparc/crypto/sha512_asm.S      |  102 ++++++
 arch/sparc/crypto/sha512_glue.c     |  226 ++++++++++++
 arch/sparc/include/asm/asi.h        |    4 +-
 arch/sparc/include/asm/elf_64.h     |    9 +
 arch/sparc/include/asm/hypervisor.h |   11 +
 arch/sparc/include/asm/mdesc.h      |    1 +
 arch/sparc/include/asm/pcr.h        |   36 +-
 arch/sparc/include/asm/perfctr.h    |   30 --
 arch/sparc/include/asm/pstate.h     |   14 +
 arch/sparc/kernel/head_64.S         |   14 +-
 arch/sparc/kernel/hvapi.c           |    1 +
 arch/sparc/kernel/hvcalls.S         |   16 +
 arch/sparc/kernel/ktlb.S            |   25 +-
 arch/sparc/kernel/mdesc.c           |   24 ++
 arch/sparc/kernel/nmi.c             |   21 +-
 arch/sparc/kernel/pci_sun4v.c       |    2 +-
 arch/sparc/kernel/pcr.c             |  172 +++++++--
 arch/sparc/kernel/perf_event.c      |  516 ++++++++++++++++++++------
 arch/sparc/kernel/setup_64.c        |   67 +++-
 arch/sparc/lib/Makefile             |    3 +
 arch/sparc/lib/NG4copy_from_user.S  |   30 ++
 arch/sparc/lib/NG4copy_page.S       |   57 +++
 arch/sparc/lib/NG4copy_to_user.S    |   39 ++
 arch/sparc/lib/NG4memcpy.S          |  360 +++++++++++++++++++
 arch/sparc/lib/NG4patch.S           |   43 +++
 arch/sparc/lib/NGpage.S             |    2 +
 arch/sparc/lib/ksyms.c              |    4 +
 arch/sparc/mm/init_64.c             |  230 +++++++++---
 arch/sparc/mm/init_64.h             |    4 +-
 crypto/Kconfig                      |   97 +++++
 drivers/crypto/n2_core.c            |    2 +-
 drivers/sbus/char/display7seg.c     |    2 +-
 drivers/sbus/char/envctrl.c         |    8 +-
 drivers/sbus/char/openprom.c        |    4 +-
 52 files changed, 6919 insertions(+), 271 deletions(-)
 create mode 100644 arch/sparc/crypto/Makefile
 create mode 100644 arch/sparc/crypto/aes_asm.S
 create mode 100644 arch/sparc/crypto/aes_glue.c
 create mode 100644 arch/sparc/crypto/camellia_asm.S
 create mode 100644 arch/sparc/crypto/camellia_glue.c
 create mode 100644 arch/sparc/crypto/crc32c_asm.S
 create mode 100644 arch/sparc/crypto/crc32c_glue.c
 create mode 100644 arch/sparc/crypto/crop_devid.c
 create mode 100644 arch/sparc/crypto/des_asm.S
 create mode 100644 arch/sparc/crypto/des_glue.c
 create mode 100644 arch/sparc/crypto/md5_asm.S
 create mode 100644 arch/sparc/crypto/md5_glue.c
 create mode 100644 arch/sparc/crypto/opcodes.h
 create mode 100644 arch/sparc/crypto/sha1_asm.S
 create mode 100644 arch/sparc/crypto/sha1_glue.c
 create mode 100644 arch/sparc/crypto/sha256_asm.S
 create mode 100644 arch/sparc/crypto/sha256_glue.c
 create mode 100644 arch/sparc/crypto/sha512_asm.S
 create mode 100644 arch/sparc/crypto/sha512_glue.c
 create mode 100644 arch/sparc/lib/NG4copy_from_user.S
 create mode 100644 arch/sparc/lib/NG4copy_page.S
 create mode 100644 arch/sparc/lib/NG4copy_to_user.S
 create mode 100644 arch/sparc/lib/NG4memcpy.S
 create mode 100644 arch/sparc/lib/NG4patch.S
