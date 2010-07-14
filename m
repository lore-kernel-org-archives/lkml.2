Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0GNGrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:47:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0GNGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=Fc+WL0fqnjg2/8jE7ZmWGmSGbTjXz+A3KJGiRO3q4HtWCdM3CT4W/iA7hS60BeuoTQ
         k6pRJKFai7El4uHBypjlQZKyYkUUyIY09zOIQhUb3rItY7XPO3lV+6ySt+WptprrmtIO
         lPkpJuWiId2us9BFmiiOkAbuCOVctNimydOJg=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 14 Jul 2010 08:47:12 +0200
Message-ID: <AANLkTimHIbkXuP_YwKHZmKS-fHXAI331BtapiH7K2XDd@mail.gmail.com>
Subject: man-pages-3.25 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.25.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/06/man-pages-325-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael


==================== Changes in man-pages-3.25 ====================

New and rewritten pages
-----------------------

migrate_pages.2
    Andi Kleen
        New page documenting migrate_pages(2).
            Andi's text based on the move_pages.2 page;
            additional edits by mtk.
            migrate_pages(2) was new in Linux 2.6.16.

quotactl.2
    Jan Kara
        Major updates
            Update the page to consolidate information from the
            outdated man-pages quotactl.2 page and the quotactl.2
            page in the "quota-tools" pachage. The page in "quota-tools"
            has now been dropped by Jan Kara, so that there is just one
            canonical quotactl.2 page (in pan-pages).
    Michael Kerrisk
            Various other pieces added to the page by mtk.


Newly documented interfaces in existing pages
---------------------------------------------

fcntl.2
    Michael Kerrisk
        Document F_SETPIPE_SZ and F_GETPIPE_SZ
            These commands, new in kernel 2.6.35, set and get the capacity
            of pipes.

madvise.2
    Andi Kleen
        Document MADV_HWPOISON
    Michael Kerrisk
        Added documentation of MADV_MERGEABLE and MADV_UNMERGEABLE
            These flags (used for Kernel Samepage Mergeing, KSM)
            are new in 2.6.32.
    Andi Kleen
        Document MADV_SOFT_OFFLINE
            This operation was added in Linux 2.6.33.

mmap.2
    Michael Kerrisk
        Document MAP_UNINITIALIZED flag
            New in Linux 2.6.33.

prctl.2
    Andi Kleen
        Document the hwpoison prctls in 2.6.32

sched_setscheduler.2
    Michael Kerrisk
        Document SCHED_RESET_ON_FORK
            New in Linux 2.6.32

umount.2
    Michael Kerrisk
        Document UMOUNT_NOFOLLOW
            New in Linux 2.6.34.

mkstemp.3
    Michael Kerrisk
        Document mkstemps() and mkostemps()
            These functions are new in glibc 2.11. They allow the template
            string to include a suffix after the "XXXXXX" string.

proc.5
    Michael Kerrisk
        Document /proc/sys/vm/memory_failure_early_kill
            New in 2.6.32. Description based on the text in
            Documentation/sysctl/vm.txt.
    Michael Kerrisk
        Document /proc/sys/vm/memory_failure_recovery
            New in Linux 2.6.32.  Description based on the text in
            Documentation/sysctl/vm.txt.
    Michael Kerrisk
        Document /proc/sys/fs/pipe-max-size

socket.7
    Jan Engelhardt
        Document SO_DOMAIN and SO_PROTOCOL
            These read-only socket options were new in Linux 2.6.32.


Changes to individual pages
---------------------------

fcntl.2
    Michael Kerrisk
        Note that glibc 2.11 papers over the kernel F_GETOWN bug
            Since version 2.11, glibc works around the kernel limitation for
            process groups IDs < 4096 by implementing F_GETOWN via F_GETOWN_EX.

sigaction.2
    Michael Kerrisk
        Add TRAP_BRANCH and TRAP_HWBKPT to si_code values for SIGTRAP
    Michael Kerrisk
        Add details for signals sent by POSIX message queue notifications
    Michael Kerrisk
        Improve description of various siginfo_t fields
    Michael Kerrisk
        Add some details for SIGTRAP and si_trapno
    Andi Kleen
        Document hwpoison signal extensions

statfs.2
    Michael Kerrisk
        Bring statfs struct type declarations closer to glibc reality
    Fang Wenqi
        Add definition EXT4_SUPER_MAGIC = 0xEF53
    Michael Kerrisk
        Document f_frsize field.

swapon.2
    Ivana Hutarova Varekova
        Note effect of CONFIG_MEMORY_FAILURE on MAX_SWAPFILES
            From 2.6.32, MAX_SWAPFILES is decreased by 1 if the kernel is
            built with CONFIG_MEMORY_FAILURE.

syscalls.2
    Michael Kerrisk
        Bring system call list up to date with Linux 2.6.33

ftw.3
    Michael Kerrisk
        Note that if 'fn' changes CWD, the results are undefined
    Michael Kerrisk
        Clarify description of fpath argument
            As reported by Pierre Habouzit, 'fpath' is not relative
            to 'dirpath'. It is either relative to the calling process's
            current working directory (if 'dirpath' was relative), or it
            is absolute (if 'dirpath' was absolute).

core.5
    Michael Kerrisk
        Update description of coredump_filter
            Kernel 2.6.24 added MMF_DUMP_ELF_HEADERS.
            Kernel 2.6.28 added MMF_DUMP_HUGETLB_PRIVATE and
            MMF_DUMP_HUGETLB_SHARED.

capabilities.7
    Michael Kerrisk
        Document CAP_SYS_RESOURCE and F_SETPIPE_SZ
            With CAP_SYS_RESOURCE, a process can increase pipe capacity above
            /proc/sys/ps/pipe-max-size.
    Michael Kerrisk
        Add get_robust_list() info under CAP_SYS_PTRACE
    Michael Kerrisk
        Add MADV_HWPOISON under CAP_SYS_ADMIN

udp.7
    Michael Kerrisk
        Add FIONREAD warning.
            Warn that FIONREAD can't can't distinguish case of a zero-length
            datagram from the case where no datagrams are available.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
