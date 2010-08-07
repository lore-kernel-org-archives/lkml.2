Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0HGMPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:15:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0HGMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=l16BEitss5JrhafcSs0BBiW0ehJ2UJwr1AALEmgLUD8uOpjfve7GJ3gew0/K8kQ9aS
         SePtxkov7L/M/KdOgZvKy3NBpe4Gm2uTypU1Ln7G2FxK+wY6Xzoa2mLzmYDz6rpyhqQ8
         AfjIBIsRYcLWYl6GGAJYOHMxc9BU1T/KOTbZQ=
Message-ID: <4C5D4E50.5050105@suse.cz>
Date: Sat, 07 Aug 2010 14:15:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT] writable_limits for 2.6.36
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

please consider the following repository for 2.6.36. It introduces a new
syscall for arch independent resource limits handling. It also adds a
support for runtime limits changing. This feature is needed mostly by
daemons servicing databases and similar service where limits are needed
to be changed without services being restarted on production systems.

The following changes since commit 2f7989efd4398d92b8adffce2e07dd043a0895fe:

  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2010-07-14 17:28:13
-0700)

are available in the git repository at:

  git://decibel.fi.muni.cz/~xslaby/linux writable_limits

Jiri Slaby (10):
      rlimits: security, add task_struct to setrlimit
      rlimits: add task_struct to update_rlimit_cpu
      rlimits: split sys_setrlimit
      rlimits: allow setrlimit to non-current tasks
      rlimits: do security check under task_lock
      rlimits: add rlimit64 structure
      rlimits: redo do_setrlimit to more generic do_prlimit
      rlimits: switch more rlimit syscalls to do_prlimit
      rlimits: implement prlimit64 syscall
      unistd: add __NR_prlimit64 syscall numbers

Oleg Nesterov (2):
      rlimits: make sure ->rlim_max never grows in sys_setrlimit
      rlimits: selinux, do rlimits changes under task_lock

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/asm-generic/unistd.h       |    4 +-
 include/linux/posix-timers.h       |    2 +-
 include/linux/resource.h           |    9 ++
 include/linux/security.h           |    9 +-
 include/linux/syscalls.h           |    4 +
 kernel/compat.c                    |   17 +---
 kernel/posix-cpu-timers.c          |    8 +-
 kernel/sys.c                       |  202
++++++++++++++++++++++++++++--------
 security/capability.c              |    3 +-
 security/security.c                |    5 +-
 security/selinux/hooks.c           |   12 ++-
 15 files changed, 207 insertions(+), 75 deletions(-)

thanks,
-- 
js
suse labs
