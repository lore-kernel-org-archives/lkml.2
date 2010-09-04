Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0IDBRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:17:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59457 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IDBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZUJjpWSVA8enkgqD9pV9B/h+d468UTVQk2Em2MxZfscvHU8s4c0NKvjG9zpT96Juxu
         N41WT8CSrqIcWwZ4mkj5eiZI7EnsLAb6fV7HG4sN3fwE9E94uu5dpt6dnllyUMJ3PZpF
         bRz3QZIX7IkNYqNCXxXys+JoVUEIePfS/Hngk=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 0/12] x86 FPU cleanups (v2)
Date: Fri,  3 Sep 2010 21:17:07 -0400
Message-Id: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set cleans up and merges the 32-bit and 64-bit FPU code.

v2:
- Don't write to %cr4 unless some bits are set
- Reworked the fpu_save_init() merge

[PATCH 01/12] x86: Use correct type for %cr4
[PATCH 02/12] x86: Merge fpu_init()
[PATCH 03/12] x86: Merge tolerant_fwait()
[PATCH 04/12] x86: Merge __save_init_fpu()
[PATCH 05/12] x86-64: Disable preemption when using TS_USEDFPU
[PATCH 06/12] x86-64: Fix %cs value in convert_from_fxsr()
[PATCH 07/12] x86-64: Simplify constraints for fxsave/fxtstor
[PATCH 08/12] x86-32: Remove math_emulate stub
[PATCH 09/12] x86: Remove unnecessary ifdefs from i387 code.
[PATCH 10/12] x86: Remove PSHUFB_XMM5_* macros
[PATCH 11/12] x86-32: Rewrite fpu_save_init()
[PATCH 12/12] x86: Merge fpu_save_init()

 arch/x86/include/asm/i387.h      |  195 ++++++++++---------------------------
 arch/x86/include/asm/processor.h |    4 +-
 arch/x86/kernel/cpu/common.c     |    7 --
 arch/x86/kernel/i387.c           |   52 +++++------
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/traps.c          |   35 +------
 6 files changed, 84 insertions(+), 211 deletions(-)

