Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1DHRfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:35:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60223 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1DHRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oVsojLwRUE09XXtiwL9349d9ZffGJlC0f1V//Mak0Y1anGLvqA1MF+dxtX5PyCxaAa
         FeO1ADwRmNuKbSMJKv7ONLab8D38N8ENUHwBqAnY7J1DS+H6hDaJJhMx9RTALpiFs7yD
         F8Ph8JB7zOK5XLaRgHsIas+6R5HEG6WJUlzOs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "v2 . 6 . 33 . ." <stable@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 0/5] hw_breakpoints: Fix racy ptrace breakpoint acccesses
Date: Fri,  8 Apr 2011 19:34:22 +0200
Message-Id: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have fixed that a few month ago but got sidetracked.
Please have a look at this. x86 and powerpc already had support
for breakpoints before so it fixes a regression there (cf stable tag)
For the others it only a fix.

Other archs than x86 have been only compile tested.

Thanks.

Frederic Weisbecker (5):
  ptrace: Prepare to fix racy accesses on task breakpoints
  x86, hw_breakpoints: Fix racy access to ptrace breakpoints
  powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
  arm, hw_breakpoints: Fix racy access to ptrace breakpoints
  sh, hw_breakpoints: Fix racy access to ptrace breakpoints

 arch/arm/kernel/ptrace.c     |    8 ++++++++
 arch/powerpc/kernel/ptrace.c |    3 +++
 arch/sh/kernel/ptrace_32.c   |    4 ++++
 arch/x86/kernel/ptrace.c     |   36 ++++++++++++++++++++++++++----------
 include/linux/ptrace.h       |   13 ++++++++++++-
 include/linux/sched.h        |    3 +++
 kernel/exit.c                |    2 +-
 kernel/ptrace.c              |   17 +++++++++++++++++
 8 files changed, 74 insertions(+), 12 deletions(-)

-- 
1.7.3.2

