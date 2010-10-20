Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0JTMQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:16:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37965 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0JTMQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=kkD4rplCeobV4KPDxzjOfifyWTj0nHdvJzcPE7FkQGZ86UC37aFFt829WMON1/e63T
         t2wy0su8Z6LHyomMrhBXENiiXPOKecYin+rR622Au7sHUdoyzP1launVmqaXT62WtTef
         HuTlq3r3P8DK7BoCEP9LrlccYgUDc4yxYU0H0=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 20 Oct 2010 14:16:28 +0200
Message-ID: <AANLkTimMhtmTpyFkwOtOh8SvH2_SKmFTm4TOt0JMZOyD@mail.gmail.com>
Subject: man-pages-3.29 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.29.

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The man-pages git repository is here:

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html (blogged at
http://linux-man-pages.blogspot.com/2010/10/man-pages-329-is-released.html
) and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.29 ====================

New and rewritten pages
-----------------------

subpage_prot.2
    Michael Kerrisk
        New page documenting the PowerPC-specific subpage_prot(2)

aio_init.3
    Michael Kerrisk
        New page documenting aio_init(3)


Newly documented interfaces in existing pages
---------------------------------------------

posix_fadvise.2
    Michael Kerrisk
        Document the architecture-specific arm_fadvise64_64() system call
            This ARM-specific system call fixes the argument ordering
            for that architecture. Since Linux 2.6.14.

sync_file_range.2
    Michael Kerrisk
        Document the architecture-specific sync_file_range2() system call
            As described in commit edd5cd4a9424f22b0fa08bef5e299d41befd5622,
            the sync_file_range() argument order is broken for some
            architectures (PowerPC, ARM, tile). The remedy was a different
            system call using the right argument order on those architectures.

psignal.3
    Guillem Jover
        Document psiginfo()
            psiginfo() was added to glibc in version 2.10.
    Michael Kerrisk
        Add details, VERSIONS, and BUGS for psiginfo()

ip.7
    Balazs Scheidler
        Document IP_RECVORIGDSTADDR
        Document IP_TRANSPARENT
    Michael Kerrisk
        Document IP_FREEBIND
            Text based on input from Lennart Poettering and Balazs Scheidler.
            See https://bugzilla.kernel.org/show_bug.cgi?id=20082


Changes to individual pages
---------------------------

unix.7
    Michael Kerrisk
        Document the autobind feature
    Michael Kerrisk
        Fix description of abstract socket names
            As reported by Lennart Poettering:
                The part about "abstract" sockets is misleading as it suggests
                that the sockaddr returned by getsockname() would necessarily
                have the size of sizeof(struct sockaddr), which however is not
                the case: getsockname() returns exactly the sockaddr size that
                was passed in on bind(). In particular, two sockets that are
                bound to the same sockaddr but different sizes are completely
                independent.
            See https://bugzilla.kernel.org/show_bug.cgi?id=19812

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
