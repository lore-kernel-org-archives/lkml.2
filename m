Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1ACLrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:47:08 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:45739 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1ACLrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:47:04 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 0/8] unicore32 additional architecture files: summary
Date: Mon, 3 Jan 2011 19:47:02 +0800
Message-ID: <012001cbab3b$f0397a70$d0ac6f50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurO+pN+WBxeXlwQ0KxysTqzMyUwg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

The whole patch could be fetched from:
  git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
  with branch name: unicore32.
And it is divided into  three patch sets: core architecture files,
  additional architecture files, and machine related files.

This patch set adds the additional architecture files for UniCore32 ISA. 

Patch 1 adds pm related files, including hibernate and sleep supports.

Patch 2 implements support for float point unit, which using UniCore-F64 FPU hardware
in UniCore32 ISA.

Patch 3 adds ptrace support.

Patch 4 implements low-level debug libraries with On-Chip-Debugger hardware support.

Patch 5 implements low-level io libraries.

Patch 6 implements low-level uaccess libraries. And using asm-generic version uaccess.h
is in my hot TODO list.

Patch 7 implements low-level checksum libraries.

Patch 8 implements the rest low-level libraries.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/assembler.h        |  131 +++++
 arch/unicore32/include/asm/bitops.h           |   47 ++
 arch/unicore32/include/asm/checksum.h         |  142 +++++
 arch/unicore32/include/asm/delay.h            |   52 ++
 arch/unicore32/include/asm/fpstate.h          |   41 ++
 arch/unicore32/include/asm/futex.h            |  143 +++++
 arch/unicore32/include/asm/io.h               |   83 +++
 arch/unicore32/include/asm/mach/debug-macro.S |   89 +++
 arch/unicore32/include/asm/mach/ocd.h         |   36 ++
 arch/unicore32/include/asm/mach/pm.h          |   32 +
 arch/unicore32/include/asm/mutex.h            |   20 +
 arch/unicore32/include/asm/ptrace.h           |  184 ++++++
 arch/unicore32/include/asm/suspend.h          |   30 +
 arch/unicore32/include/asm/swab.h             |   28 +
 arch/unicore32/include/asm/uaccess.h          |  429 ++++++++++++++
 arch/unicore32/include/asm/uc-f64.h           |   60 ++
 arch/unicore32/kernel/clock.c                 |  399 +++++++++++++
 arch/unicore32/kernel/cpu-ucv2.c              |  100 ++++
 arch/unicore32/kernel/debug.S                 |   85 +++
 arch/unicore32/kernel/early_printk.c          |   59 ++
 arch/unicore32/kernel/hibernate.c             |  167 ++++++
 arch/unicore32/kernel/hibernate.h             |    9 +
 arch/unicore32/kernel/hibernate_asm.S         |  124 ++++
 arch/unicore32/kernel/pm.c                    |  129 ++++
 arch/unicore32/kernel/ptrace.c                |  600 +++++++++++++++++++
 arch/unicore32/kernel/ptrace.h                |   53 ++
 arch/unicore32/kernel/sleep.S                 |  208 +++++++
 arch/unicore32/lib/Makefile                   |   16 +
 arch/unicore32/lib/clear_user.S               |   59 ++
 arch/unicore32/lib/copy_from_user.S           |  107 ++++
 arch/unicore32/lib/copy_page.S                |   39 ++
 arch/unicore32/lib/copy_template.S            |  214 +++++++
 arch/unicore32/lib/copy_to_user.S             |   97 +++
 arch/unicore32/lib/csumipv6.S                 |   36 ++
 arch/unicore32/lib/csumpartial.S              |  126 ++++
 arch/unicore32/lib/csumpartialcopy.S          |   61 ++
 arch/unicore32/lib/csumpartialcopygeneric.S   |  335 +++++++++++
 arch/unicore32/lib/csumpartialcopyuser.S      |   92 +++
 arch/unicore32/lib/delay.S                    |   51 ++
 arch/unicore32/lib/findbit.S                  |   98 ++++
 arch/unicore32/lib/getuser.S                  |   65 ++
 arch/unicore32/lib/io-readsb.S                |  130 +++++
 arch/unicore32/lib/io-readsl.S                |   83 +++
 arch/unicore32/lib/io-readsw.S                |  110 ++++
 arch/unicore32/lib/io-writesb.S               |   90 +++
 arch/unicore32/lib/io-writesl.S               |   69 +++
 arch/unicore32/lib/io-writesw.S               |   87 +++
 arch/unicore32/lib/putuser.S                  |   73 +++
 arch/unicore32/lib/sha1.S                     |  200 +++++++
 arch/unicore32/lib/strncpy_from_user.S        |   45 ++
 arch/unicore32/lib/strnlen_user.S             |   42 ++
 arch/unicore32/uc-f64/Makefile                |   13 +
 arch/unicore32/uc-f64/entry.S                 |   33 +
 arch/unicore32/uc-f64/f64_double_cmp.h        |  245 ++++++++
 arch/unicore32/uc-f64/f64_single_cmp.h        |  245 ++++++++
 arch/unicore32/uc-f64/f64double.c             |  758 ++++++++++++++++++++++++
 arch/unicore32/uc-f64/f64hw.S                 |  155 +++++
 arch/unicore32/uc-f64/f64instr.h              |  101 ++++
 arch/unicore32/uc-f64/f64module.c             |  180 ++++++
 arch/unicore32/uc-f64/f64single.c             |  771 +++++++++++++++++++++++++
 arch/unicore32/uc-f64/f64sint.c               |   94 +++
 arch/unicore32/uc-f64/uc-f64.h                |  332 +++++++++++
 62 files changed, 8732 insertions(+), 0 deletions(-)

