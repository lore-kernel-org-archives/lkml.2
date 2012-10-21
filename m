Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2JUGk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 02:40:29 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35817 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2JUGk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 02:40:28 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 21 Oct 2012 08:40:05 +0200
Message-ID: <CAKgNAkjN-MaGyCKANvM7E-_H2Ct323tc6E=nAEX=gyrzLvbpTw@mail.gmail.com>
Subject: man-pages-3.43 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.43.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.43

A short summary of the release is blogged at:
linux-man-pages.blogspot.com/2012/10/man-pages-343-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.43 ====================


Newly documented interfaces in existing pages
---------------------------------------------

getenv.3
    Michael Kerrisk  [Florian Weimer, Andreas Schwab]
        Document secure_getenv(3)


Changes to individual pages
---------------------------

epoll_wait.2
    Michael Kerrisk  [Fredrik Arnerup]
        Describe timeout limitation in kernels < 2.6.37
            The timeout argument has an upper limit. Any values above that
            limit are treated the same as -1, i.e. to wait indefinitely.
            The limit is given by:

                #define EP_MAX_MSTIMEO min(1000ULL *
MAX_SCHEDULE_TIMEOUT / HZ, \
                (LONG_MAX - 999ULL) / HZ)

            That is, the limit depends on the size of a long and the timer
            frequency.  Assuming the a long is never smaller than 32 bits
            and HZ never larger than 1000, the worst case is 35 minutes.
            I think this should be mentioned under "BUGS".

            Although this is likely to be fixed in the future
            (http://lkml.org/lkml/2010/8/8/144), the problem exists in
            at least 2.6.14 - 2.6.35. I don't know if select(2) and poll(2)
            are affected.

            https://bugzilla.kernel.org/show_bug.cgi?id=20762
    Michael Kerrisk
        Add pointer to select(2) for discussion of close in another thread

getitimer.2
    Michael Kerrisk  [Trevor Woerner]
        Note Linux's odd handling of the new_value==NULL case

select.2
    Michael Kerrisk  [Stephane Fillod]
        Note behavior if monitored file descriptor is closed in another thread
            Executive summary: a sane application can't rely on any
            particular behavior if another thread closes a file descriptor
            being monitored by select().

            See https://bugzilla.kernel.org/show_bug.cgi?id=40852

syslog.3
    Simon Josefsson
        Remove (apparently bogus) text claiming LOG_AUTH is deprecated
            LOG_AUTH is in POSIX, and widely available. There
            seems to be no basis to the claim it is deprecated.

            See https://bugzilla.kernel.org/show_bug.cgi?id=46091

proc.5
    Michael Kerrisk
        Document /proc/sys/kernel/kptr_restrict
    Michael Kerrisk [Kees Cook]
        Document /proc/sys/fs/protected_symlinks
            Based on text in Documentation/sysctl/fs.txt by Kees Cook
    Michael Kerrisk [Kees Cook]
        Document /proc/sys/fs/protected_hardlinks
            Based on text in Documentation/sysctl/fs.txt by Kees Cook

capabilities.7
    Michael Kerrisk
        Document interaction of CAP_SYSLOG and /proc/sys/kernel/kptr_restrict

ld.so.8
    Michael Kerrisk
        Describe interpretation of slashes in dependency strings
    Michael Kerrisk
        Repeat note that LD_LIBRARY_PATH is ignored in privileged programs
            This point is already noted when discussing search order for
            libraries, but it's worth repeating under the specific discussion
            of LD_LIBRARY_PATH further down the page.
    Michael Kerrisk
        Add some details for LD_PRELOAD

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
