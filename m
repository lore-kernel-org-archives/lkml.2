Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1CWVLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:11:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33816 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab1CWVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:11:07 -0400
Date: Wed, 23 Mar 2011 21:11:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs and procfs fixes
Message-ID: <20110323211106.GC22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for a couple of dumb leaks in path_lookupat() and a large pile of
procfs fixes.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (7):
      fix leaks in path_lookupat()
      make sessionid permissions in /proc/*/task/* match those in /proc/*
      pagemap: close races with suid execve
      report errors in /proc/*/*map* sanely
      close race in /proc/*/environ
      auxv: require the target to be tracable (or yourself)
      deal with races in /proc/*/{syscall,stack,personality}

Stephen Wilson (12):
      x86: add context tag to mark mm when running a task in 32-bit compatibility mode
      x86: mark associated mm when running a task in 32 bit compatibility mode
      mm: arch: make get_gate_vma take an mm_struct instead of a task_struct
      mm: arch: make in_gate_area take an mm_struct instead of a task_struct
      mm: arch: rename in_gate_area_no_task to in_gate_area_no_mm
      mm: use mm_struct to resolve gate vma's in __get_user_pages
      mm: factor out main logic of access_process_vm
      mm: implement access_remote_vm
      proc: disable mem_write after exec
      proc: hold cred_guard_mutex in check_mem_permission()
      proc: make check_mem_permission() return an mm_struct on success
      proc: enable writing to /proc/pid/mem

Diffstat:
 arch/powerpc/kernel/vdso.c         |    6 +-
 arch/s390/kernel/vdso.c            |    6 +-
 arch/sh/kernel/vsyscall/vsyscall.c |    6 +-
 arch/x86/ia32/ia32_aout.c          |    1 +
 arch/x86/include/asm/mmu.h         |    6 +
 arch/x86/kernel/process_64.c       |    8 ++
 arch/x86/mm/init_64.c              |   16 ++--
 arch/x86/vdso/vdso32-setup.c       |   15 ++--
 fs/binfmt_elf.c                    |    2 +-
 fs/namei.c                         |    7 +-
 fs/proc/base.c                     |  178 ++++++++++++++++++++++++------------
 fs/proc/task_mmu.c                 |   23 ++---
 fs/proc/task_nommu.c               |    6 +-
 include/linux/mm.h                 |   12 ++-
 kernel/kallsyms.c                  |    4 +-
 mm/memory.c                        |   73 +++++++++++----
 mm/mlock.c                         |    4 +-
 mm/nommu.c                         |    2 +-
 18 files changed, 244 insertions(+), 131 deletions(-)
