Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab1FKAwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:52:49 -0400
Received: from smtp.waikato.ac.nz ([130.217.66.62]:44014 "EHLO
	smtp.waikato.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab1FKAwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:52:47 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 20:52:46 EDT
Message-ID: <4DF2B74F.50700@waikato.ac.nz>
Date: Sat, 11 Jun 2011 12:31:11 +1200
From: Michael Cree <cree@waikato.ac.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-alpha@vger.kernel.org
Subject: 2.6.39.1 Regression: testsuite failures in eglibc on Alpha
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While building eglibc (Debian version 2.13-5) test suite failures are
reported when running under the 2.6.39.1 kernel, but not when running
under the 2.6.38.6 kernel on the Alpha arch.  The failures are:

tst-mutexpi4.out, Error 1
tst-mutexpi7.out, Error 1
tst-mutexpi7a.out, Error 1
tst-robust1.out, Error 1
tst-robust3.out, Error 1
tst-robust4.out, Error 1
tst-robust6.out, Error 1
tst-robust7.out, Error 1
tst-robust8.out, Error 1
tst-robust9.out, Error 1
tst-robustpi1.out, Error 1
tst-robustpi3.out, Error 1
tst-robustpi4.out, Error 1
tst-robustpi6.out, Error 1
tst-robustpi7.out, Error 1
tst-robustpi8.out, Error 1

Some of the above tests time out, for example:

GCONV_PATH=/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/iconvdata
LC_ALL=C     /«BUILDDIR»/eglibc-2
.13/build-tree/alpha-libc/elf/ld-linux.so.2 --library-path
/«BUILDDIR»/eglibc-2.13/build-tree/alpha-
libc:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/math:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-lib
c/elf:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/dlfcn:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-l
ibc/nss:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/nis:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-l
ibc/rt:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/resolv:/«BUILDDIR»/eglibc-2.13/build-tree/alpha
-libc/crypt:/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/nptl
/«BUILDDIR»/eglibc-2.13/build-tree/al
pha-libc/nptl/tst-mutexpi7  >
/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/nptl/tst-mutexpi7.out
Timed out: killed the child process
make[3]: ***
[/«BUILDDIR»/eglibc-2.13/build-tree/alpha-libc/nptl/tst-mutexpi7.out]
Error 1

Since no problems are seen with the 2.6.38 kernel series this appears to
be a 2.6.39[.1] regression.

Cheers
Michael.
