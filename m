Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2DGTBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:01:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38527 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2DGTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:00:59 -0400
Subject: [PATCH v2 00/10] mm: vma->vm_flags diet
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 07 Apr 2012 23:00:49 +0400
Message-ID: <20120407185546.9726.62260.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set moves/kills some VM_* flags in vma->vm_flags bit-field,
as result there appears four free bits.

changes from v1:

* "mm, drm/udl: fixup vma flags on mmap" already merged
* two new x86/PAT cleanup/rework patches from Suresh Siddha
* "mm: kill vma flag VM_EXECUTABLE" splitted into three pieces

---

Konstantin Khlebnikov (8):
      mm, x86, pat: rework linear pfn-mmap tracking
      mm: introduce vma flag VM_ARCH_1
      mm: kill vma flag VM_CAN_NONLINEAR
      mm: kill vma flag VM_INSERTPAGE
      mm: use mm->exe_file instead of first VM_EXECUTABLE vma->vm_file
      mm: kill vma flag VM_EXECUTABLE
      mm: kill mm->num_exe_file_vmas and keep mm->exe_file until final mmput()
      mm: move madvise vma flags to the end

Suresh Siddha (2):
      x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn vma routines
      x86, pat: separate the pfn attribute tracking for remap_pfn_range and vm_insert_pfn


 arch/powerpc/oprofile/cell/spu_task_sync.c |   15 +----
 arch/tile/mm/elf.c                         |   19 ++----
 arch/x86/mm/pat.c                          |   89 ++++++++++++++++++++--------
 drivers/oprofile/buffer_sync.c             |   17 +----
 drivers/staging/android/ashmem.c           |    1 
 fs/9p/vfs_file.c                           |    1 
 fs/btrfs/file.c                            |    2 -
 fs/ceph/addr.c                             |    2 -
 fs/cifs/file.c                             |    1 
 fs/ecryptfs/file.c                         |    1 
 fs/ext4/file.c                             |    2 -
 fs/fuse/file.c                             |    1 
 fs/gfs2/file.c                             |    2 -
 fs/nfs/file.c                              |    1 
 fs/nilfs2/file.c                           |    2 -
 fs/ocfs2/mmap.c                            |    2 -
 fs/ubifs/file.c                            |    1 
 fs/xfs/xfs_file.c                          |    2 -
 include/asm-generic/pgtable.h              |   57 +++++++++++-------
 include/linux/fs.h                         |    2 +
 include/linux/mm.h                         |   69 +++++++++-------------
 include/linux/mm_types.h                   |    1 
 include/linux/mman.h                       |    1 
 kernel/auditsc.c                           |   12 +---
 kernel/fork.c                              |   24 --------
 mm/filemap.c                               |    2 -
 mm/filemap_xip.c                           |    3 +
 mm/fremap.c                                |   14 +++-
 mm/huge_memory.c                           |   10 +--
 mm/ksm.c                                   |    9 ++-
 mm/memory.c                                |   37 +++++++-----
 mm/mmap.c                                  |   32 ++--------
 mm/nommu.c                                 |   19 +++---
 mm/shmem.c                                 |    3 -
 security/tomoyo/util.c                     |    9 +--
 35 files changed, 222 insertions(+), 243 deletions(-)

-- 
Signature
