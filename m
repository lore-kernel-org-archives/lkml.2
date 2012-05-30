Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab2E3BVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:21:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50069 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2E3BVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:21:39 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 30 May 2012 13:21:15 +1200
Message-ID: <CAKgNAkg3RUDg+fdCuteB8tdgnB3=qjKPnDir-bayYZLCYo4Phw@mail.gmail.com>
Subject: man-pages-3.41 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.41.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.41

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/05/man-pages-341-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.41 ====================


New and rewritten pages
-----------------------

get_robust_list.2
    Ivana Varekova  [Michael Kerrisk]
        New page documenting get_robust_list(2) and set_robust_list(2)

mallinfo.3
    Michael Kerrisk [KOSAKI Motohiro, Paul Pluzhnikov]
        New page for mallinfo(3)

malloc_info.3
    Michael Kerrisk  [Jakub Jelinek]
        New page for malloc_info(3)

malloc_stats.3
    Michael Kerrisk  [KOSAKI Motohiro]
        New man page for malloc_stats(3)


Newly documented interfaces in existing pages
---------------------------------------------

madvise.2
    Jason Baron
        Document MADV_DONTDUMP and MADV_DODUMP


Changes to individual pages
---------------------------

clock_getres.2
    Michael Kerrisk  [Josh Triplett]
        Expand description of CLOCK_REALTIME
            Make it clear that this clock may be discontinuous, and is
            affected my incremental NTP and clock-adjtime(2) adjustments.

            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=540872

io_cancel.2
io_destroy.2
io_getevents.2
io_setup.2
io_submit.2
    Michael Kerrisk
        Rewrite to focus on system call API
            Rewrite to focus on the system call interface, adding
            some notes on the libaio wrapper differences.
            See the following mail:
            2012-05-07 "aio manuals", linux-man@vger.kernel.org
            http://thread.gmane.org/gmane.linux.man/1935/focus=2910

open.2
    Nick Piggin  [KOSAKI Motohiro, Jan Kara, Hugh Dickins]
        Describe race of direct I/O and fork()
            Rework 04cd7f64, which didn't capture the details correctly.
            See the April/May 2012 linux-man@ mail thread "[PATCH]
            Describe race of direct read and fork for unaligned buffers"
            http://thread.gmane.org/gmane.linux.kernel.mm/77571

poll.2
    Michael Kerrisk
        Clarify that 'timeout' is a *minimum* interval
            Make it clear that 'timeout' is a minimum interval; the actual
            interval will be rounded up to the system clock granularity,
            and may overrun because of kernel scheduling delays.
    Michael Kerrisk
        Clarify discussion of wrapper function emulation
            Clarify that glibc (as well as old libc) provides emulation
            using select(2) on older kernels that don't have a poll()
            system call.
    Michael Kerrisk
        Make the meaning of a zero timeout explicit
            Clarify that timeout==0 causes an immediate return, even if
            no file descriptors are ready.

pread.2
    Michael Kerrisk  [Kasper Dupont]
        BUGS: Note O_APPEND + pwrite() does the wrong thing
            See https://bugzilla.kernel.org/show_bug.cgi?id=43178

select.2
    Michael Kerrisk
        Clarify that 'timeout' is a *minimum* interval
            Make it clear that 'timeout' is a minimum interval; the actual
            interval will be rounded up to the system clock granularity,
            and may overrun because of kernel scheduling delays.
    Michael Kerrisk
        Expand description of the self-pipe trick
    Michael Kerrisk
        Add further details on pselect6() system call that underlies pselect()

proc.5
    Michael Kerrisk
        Note that CAP_SYS_ADMIN processes can override file-max
            Upstreamed from red Hat / Fedora
    Michael Kerrisk
        Document  /proc/[pid]/cgroup
            Upstreamed from Red Hat / Fedora

ipv6.7
    Stefan Puiu
        Add ENODEV error for bind() to link-local IPv6 address


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
