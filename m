Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0KIJGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:06:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KIJGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=rd6Cp5/eK/4LfbqSI2Yr7Sqivfj7ov50m5AfJ7o7DjsLSC56S+GC72ghDPmlkvSU9u
         ISRFgQiFwwq+aONfRYQsM6irfQLeS/HVbfw88eBPYIL6ZmSUh/O242UXTMCVu2pvlS08
         +c6/qh77qFwQsPMjlr1p5RIKbehZKlXcBRTSM=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH 0/4] ARM kdump fixes
Date: Tue,  9 Nov 2010 11:06:09 +0200
Message-Id: <cover.1289292124.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is a set of patches which I hope allows us to build
crashkernels on ARM platforms. The first patch is needed so that we
can get rid of a compiler warning when building /proc/vmcore on
32-bit only platform. I think it should go via Andrew's tree (if
accepted, that is).

Patches 2 and 3 should replace following patches which are in
Russell's patch tracker:

	6121/1 allow passing an ELF64 header to elf_check_arch()
	-> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6121/1

	6123/1 kdump: add CONFIG_CRASH_DUMP Kconfig option
	-> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6123/1

The last patch converts reserve_crashkernel() to use memblock.

Thanks,
MW

Mika Westerberg (4):
  proc/vmcore: allow archs to override vmcore_elf_check_arch()
  ARM: provide zero vmcore_elf64_check_arch()
  ARM: add CONFIG_CRASH_DUMP to Kconfig
  ARM: memblock: convert reserve_crashkernel() to use memblock

 arch/arm/Kconfig           |   13 +++++++++++++
 arch/arm/include/asm/elf.h |    2 ++
 arch/arm/kernel/setup.c    |   21 +++++++--------------
 fs/proc/vmcore.c           |    2 +-
 include/linux/crash_dump.h |    9 ++++++++-
 5 files changed, 31 insertions(+), 16 deletions(-)

-- 
1.7.2.3

