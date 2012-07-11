Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab2GKPcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:32:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51558 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab2GKPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:32:39 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: davem@davemloft.net, chris@zankel.net, catalin.marinas@arm.com,
        arnd@arndb.de, cmetcalf@tilera.com, akpm@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 0/3] random compat IPC fixes required by AArch64
Date: Wed, 11 Jul 2012 16:32:18 +0100
Message-Id: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series includes some fixes to the compat IPC code when the
compat and native targets have API differences that weren't previously
considered. The problems were found during development of the AArch64
port and, as such, are prerequisities for the merging of that code.

All feedback and comments welcome (but please resist the urge to talk
about the name -- there's another thread for that on LKML :).

Will


Will Deacon (3):
  ipc: add COMPAT_SHMLBA support
  ipc: allow compat IPC version field parsing if
    !ARCH_WANT_OLD_COMPAT_IPC
  ipc: compat: use signed size_t types for msgsnd and msgrcv

 arch/sparc/kernel/sys_sparc_64.c |    2 +-
 arch/xtensa/kernel/syscall.c     |    2 +-
 include/linux/compat.h           |    5 +++--
 include/linux/shm.h              |    6 ++++--
 ipc/compat.c                     |   18 +++++++++++-------
 ipc/shm.c                        |    9 +++++----
 ipc/syscall.c                    |    2 +-
 7 files changed, 26 insertions(+), 18 deletions(-)

-- 
1.7.4.1

