Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2LVSMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 13:12:42 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:32840 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2LVSMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 13:12:40 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 22 Dec 2012 19:12:19 +0100
Message-ID: <CAKgNAkjsorV53uxtWbOsrDR0FxvRpWKO4x9JcvsmkfyU42_vhA@mail.gmail.com>
Subject: man-pages-3.45 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.45.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.45

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/12/man-pages-345-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.45 ====================

New and rewritten pages
-----------------------

s390_runtime_instr.2
    Jan Glauber
        New page for s390-specific s390_runtime_instr(2)

if_nameindex.3
    YOSHIFUJI Hideaki
        Document if_nameindex(3) and if_freenameindex(3)
    Michael Kerrisk
        Edits, improvements and corrections to Hideaki's page
    Michael Kerrisk
        Add an example program

if_nametoindex.3
    YOSHIFUJI Hideaki
        New page documenting if_nametoindex(3) and if_indextoname(3)


Changes to individual pages
---------------------------

clone.2
    Michael Kerrisk
        Since 2.6.30, CLONE_NEWIPC also supports POSIX message queues

getrlimit.2
    Michael Kerrisk  [Trevor Woerner]
        Document Linux's nonstandard treatment or RLIMIT_CPU soft limit
            Upon encountering the RLIMIT_CPU soft limit when a SIGXCPU handler
            has been installed, Linux invokes the signal handler *and* raises
            the soft limit by one second. This behavior repeats until the
            limit is encountered.  No other implementation that I tested
            (Solaris 10, FreeBSD 9.0, OpenBSD 5.0) does this, and it seems
            unlikely to be POSIX-conformant. The (Linux-specific)
            RLIMIT_RTTIME soft limit exhibits similar behavior.

recv.2
    Michael Kerrisk  [Eric Dumazet]
        UNIX domain sockets support MSG_TRUNC since 3.4

sendmmsg.2
    Elie De Brauwer
        Add example program for sendmmsg()

stat.2
    Simon Paillard
        Clarify description of EOVERFLOW error
            The EOVERFLOW error is not only for st_size, but also
            inode and block size fields. See glibc source file
            sysdeps/unix/sysv/linux/xstatconv.c and kernel source
            file fs/stat.c. Also, fix bit/byte confusion
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=604928

syslog.2
    Michael Kerrisk
        Substantially reorganize discussion of commands
            Make the layout of the discussion of the commands
            more readable.
    Michael Kerrisk
        Add kernel symbolic 'type' names
    Michael Kerrisk
        Clarify SYSLOG_ACTION_SIZE_UNREAD semantics
            SYSLOG_ACTION_SIZE_UNREAD returns the number of bytes
            available for reading via SYSLOG_ACTION_READ.
    Michael Kerrisk
        Clarify where SYSLOG_ACTION_READ_ALL places data it reads
    Michael Kerrisk
        Clarify semantics of SYSLOG_ACTION_CLEAR
            The SYSLOG_ACTION_CLEAR command (5) does not really clear
            the ring buffer; rather it affects the semantics of what
            is returned by commands 3 (SYSLOG_ACTION_READ_ALL) and
            4 (SYSLOG_ACTION_READ_CLEAR).
    Michael Kerrisk
        Clarify discussion of privileges for commands 3 and 10
    Michael Kerrisk
        Add mention of CONFIG_LOG_BUF_SHIFT

wait.2
    Michael Kerrisk
        BUGS: Document odd waitid() behavior when 'infop' is NULL

getifaddrs.3
    Michael Kerrisk  [Julien Cristau]
        Update description of ifa_data to Linux 2.6+ reality
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=526778

proc.5
    Michael Kerrisk  [Jim Paris]
        Correct description of SwapFree in /proc/meminfo
    Michael Kerrisk
        Note change of /proc/[pid]/limits file permissions in 2.6.36

ipv6.7
    Gao Feng
        Add description of getsockopt() for IPV6_MTU
            In IPv4,IP_MTU is only supported by getsockopt.
            In IPv6, we can use IPV6_MTU to set socket's MTU,
            but the return value of getsockopt() is the path MTU.

rtnetlink.7
    Michael Kerrisk  [Julien Cristau]
        Update description of IFLA_STATS to Linux 2.6+ reality
            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=526778

socket.7
    Michael Kerrisk  [YOSHIFUJI Hideaki]
        Document 'sockaddr' and 'sockaddr_storage' types
    Andi Kleen
        Explain effect of SO_SNDTIMEO for connect()
            When SO_SNDTIMEO is set before connect(), then connect()
            may return EWOULDBLOCK when the timeout fires.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
