Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2AQVec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:34:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44923 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2AQVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:34:31 -0500
Date: Tue, 17 Jan 2012 21:34:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] aush^H^Hdit queue
Message-ID: <20120117213429.GS23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	By all rights it's Eric's stuff; I hadn't got around to resurrecting
audit.git until the end of December and this is what was in his tree (minus
a couple of things obsoleted by Miklos' "fsnotify: don't BUG in
fsnotify_destroy_mark()").  Please, pull from
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/audit.git for-linus

Shortlog:
Eric Paris (23):
      audit: make filetype matching consistent with other filters
      audit: dynamically allocate audit_names when not enough space is in the names array
      audit: drop the meaningless and format breaking word 'user'
      audit: check current inode and containing object when filtering on major and minor
      seccomp: audit abnormal end to a process due to seccomp
      Audit: push audit success and retcode into arch ptrace.h
      audit: ia32entry.S sign extend error codes when calling 64 bit code
      audit: inline audit_syscall_entry to reduce burden on archs
      audit: remove AUDIT_SETUP_CONTEXT as it isn't used
      audit: drop some potentially inadvisable likely notations
      audit: inline checks for not needing to collect aux records
      audit: drop audit_set_macxattr as it doesn't do anything
      audit: inline audit_free to simplify the look of generic code
      audit: reject entry,always rules
      audit: remove audit_finish_fork as it can't be called
      audit: allow matching on obj_uid
      audit: allow audit matching on inode gid
      audit: remove task argument to audit_set_loginuid
      audit: only allow tasks to set their loginuid if it is -1
      audit: do not call audit_getname on error
      audit: allow interfield comparison in audit rules
      audit: complex interfield comparison helper
      audit: allow interfield comparison between gid and ogid

Kees Cook (2):
      audit: treat s_id as an untrusted string
      audit: no leading space in audit_log_d_path prefix

Nathaniel Husted (1):
      Kernel: Audit Support For The ARM Platform

Peter Moody (2):
      audit: implement all object interfield comparisons
      audit: comparison on interprocess fields

Xi Wang (1):
      audit: fix signedness bug in audit_log_execve_info()

Diffstat:
 arch/arm/include/asm/kprobes.h       |    1 -
 arch/arm/include/asm/ptrace.h        |    5 +
 arch/arm/include/asm/thread_info.h   |    6 +
 arch/arm/kernel/entry-common.S       |    4 +-
 arch/arm/kernel/ptrace.c             |   16 +-
 arch/ia64/include/asm/ptrace.h       |   13 +-
 arch/ia64/kernel/ptrace.c            |   18 +-
 arch/microblaze/include/asm/ptrace.h |    5 +
 arch/microblaze/kernel/ptrace.c      |    9 +-
 arch/mips/include/asm/ptrace.h       |   14 +-
 arch/mips/kernel/ptrace.c            |   11 +-
 arch/powerpc/include/asm/ptrace.h    |   13 +-
 arch/powerpc/kernel/ptrace.c         |   30 +-
 arch/s390/include/asm/ptrace.h       |    6 +-
 arch/s390/kernel/ptrace.c            |   15 +-
 arch/sh/include/asm/ptrace_32.h      |    5 +-
 arch/sh/include/asm/ptrace_64.h      |    5 +-
 arch/sh/kernel/ptrace_32.c           |   11 +-
 arch/sh/kernel/ptrace_64.c           |   11 +-
 arch/sparc/include/asm/ptrace.h      |   10 +-
 arch/sparc/kernel/ptrace_64.c        |   28 +-
 arch/um/kernel/ptrace.c              |   20 +-
 arch/x86/ia32/ia32entry.S            |   14 +-
 arch/x86/kernel/entry_32.S           |   10 +-
 arch/x86/kernel/entry_64.S           |   14 +-
 arch/x86/kernel/ptrace.c             |   25 +-
 arch/x86/kernel/vm86_32.c            |    4 +-
 arch/x86/um/shared/sysdep/ptrace.h   |    5 +
 arch/xtensa/kernel/ptrace.c          |    3 +-
 fs/namei.c                           |   28 +-
 fs/proc/base.c                       |    5 +-
 include/linux/audit.h                |  116 +++++-
 include/linux/ptrace.h               |   10 +
 init/Kconfig                         |   16 +-
 kernel/audit.c                       |    4 +-
 kernel/audit.h                       |    6 +-
 kernel/auditfilter.c                 |   17 +-
 kernel/auditsc.c                     |  735 +++++++++++++++++++++-------------
 kernel/exit.c                        |    3 +-
 kernel/fork.c                        |    2 -
 kernel/seccomp.c                     |    2 +
 security/integrity/ima/ima_audit.c   |    8 +-
 security/lsm_audit.c                 |   27 +-
 43 files changed, 810 insertions(+), 500 deletions(-)
