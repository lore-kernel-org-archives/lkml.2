Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab2JKRIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:08:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47826 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab2JKRIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:08:44 -0400
Date: Thu, 11 Oct 2012 18:08:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64: UAPI disintegration
Message-ID: <20121011170836.GE10659@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Oct 2012 17:08:37.0726 (UTC) FILETIME=[0DEE1FE0:01CDA7D3]
X-MC-Unique: 112101118084100901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the UAPI disintegration patches for arm64? Thanks.


The following changes since commit 12250d843e8489ee00b5b7726da855e51694e792:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-10-11 10:27:51 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-uapi

for you to fetch changes up to 48b3b3215f6bc33986f275a0cff508bd9b23fd86:

  Merge tag 'disintegrate-arm64-20121011' of git://git.infradead.org/users/dhowells/linux-headers into uapi (2012-10-11 11:51:41 +0100)

----------------------------------------------------------------

UAPI headers for arm64 together with some clean-up to make it possible:
- Do not export the COMPAT_* definitions to user
- Simplify the compat unistd32.h definitions and remove the
  __SYSCALL_COMPAT guard
- Disintegrate the arch/arm64/include/asm/* headers

----------------------------------------------------------------
Catalin Marinas (4):
      arm64: Remove unused definitions from asm/unistd32.h
      arm64: Do not include asm/unistd32.h in asm/unistd.h
      arm64: Do not export the compat-specific definitions to the user
      Merge tag 'disintegrate-arm64-20121011' of git://git.infradead.org/users/dhowells/linux-headers into uapi

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/arm64/include/asm

 arch/arm64/include/asm/Kbuild                   |    2 -
 arch/arm64/include/asm/hwcap.h                  |    9 +-
 arch/arm64/include/asm/ptrace.h                 |   75 +-
 arch/arm64/include/asm/sigcontext.h             |   40 +-
 arch/arm64/include/asm/stat.h                   |    5 +-
 arch/arm64/include/asm/unistd.h                 |   20 +-
 arch/arm64/include/asm/unistd32.h               | 1105 ++++++++---------------
 arch/arm64/include/uapi/asm/Kbuild              |   14 +
 arch/arm64/include/{ => uapi}/asm/auxvec.h      |    0
 arch/arm64/include/{ => uapi}/asm/bitsperlong.h |    0
 arch/arm64/include/{ => uapi}/asm/byteorder.h   |    0
 arch/arm64/include/{ => uapi}/asm/fcntl.h       |    0
 arch/arm64/include/uapi/asm/hwcap.h             |   26 +
 arch/arm64/include/{ => uapi}/asm/param.h       |    0
 arch/arm64/include/uapi/asm/ptrace.h            |   91 ++
 arch/arm64/include/{ => uapi}/asm/setup.h       |    0
 arch/arm64/include/uapi/asm/sigcontext.h        |   57 ++
 arch/arm64/include/{ => uapi}/asm/siginfo.h     |    0
 arch/arm64/include/{ => uapi}/asm/signal.h      |    0
 arch/arm64/include/uapi/asm/stat.h              |   16 +
 arch/arm64/include/{ => uapi}/asm/statfs.h      |    0
 arch/arm64/include/uapi/asm/unistd.h            |   16 +
 arch/arm64/kernel/entry.S                       |    1 +
 arch/arm64/kernel/ptrace.c                      |    6 +-
 arch/arm64/kernel/signal32.c                    |   22 +-
 arch/arm64/kernel/sys32.S                       |  126 +--
 arch/arm64/kernel/sys_compat.c                  |    4 +-
 27 files changed, 637 insertions(+), 998 deletions(-)
 rename arch/arm64/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/hwcap.h
 rename arch/arm64/include/{ => uapi}/asm/param.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/ptrace.h
 rename arch/arm64/include/{ => uapi}/asm/setup.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/sigcontext.h
 rename arch/arm64/include/{ => uapi}/asm/siginfo.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/signal.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/stat.h
 rename arch/arm64/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/unistd.h

