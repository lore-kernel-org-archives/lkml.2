Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2IQDPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:15:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56714 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2IQDPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:15:50 -0400
Message-ID: <505695E3.7040603@gmail.com>
Date: Sun, 16 Sep 2012 22:15:47 -0500
From: Bruce Dubbs <bruce.dubbs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120628 Firefox/13.0.1 SeaMonkey/2.10.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Subject: Re: [ANNOUNCE] kmod 10
References: <CAMOw1v6MYW6O2f4AR9yRvh200j5R6mFTRqDT3TFbG-TjknmUmw@mail.gmail.com> <alpine.LNX.2.01.1209170427220.6182@nerf07.vanv.qr>
In-Reply-To: <alpine.LNX.2.01.1209170427220.6182@nerf07.vanv.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>
> On Thursday 2012-09-06 21:37, Lucas De Marchi wrote:
>>
>> kmod 10 is out:
>>
>> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.xz
>> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.sign
>
> make check fails here with glibc-2.15, gcc-4.7, x86_64,
> due to what seems to be duplicated symbols(?)

On my LFS system, glibc-2.16, gcc-4.7.1, x86_64, I do not see these errors:

./configure --prefix=/usr --bindir=/bin --libdir=/lib \
             --sysconfdir=/etc --with-xz --with-zlib
make
make check

==================
All 9 tests passed
==================

What is interesting is that if I run the checks again:

make check

I get:

TESTSUITE: running modprobe_softdep_loop, in forked context
TESTSUITE: ERR: rootfs 
/usr/src/kmod/kmod-10/testsuite/rootfs/test-modprobe/softdep-loop is 
dirty, please run 'make rootfs' before runnning this test
TESTSUITE: ERR: 'modprobe_softdep_loop' [16407] exited with return code 1
TESTSUITE: ERR: FAILED: modprobe_softdep_loop
FAIL: testsuite/test-modprobe

TESTSUITE: running test_insert, in forked context
TESTSUITE: ERR: rootfs /usr/src/kmod/kmod-10/testsuite/rootfs/test-init/ 
is dirty, please run 'make rootfs' before runnning this test
TESTSUITE: ERR: 'test_insert' [16373] exited with return code 1
TESTSUITE: ERR: FAILED: test_insert
FAIL: testsuite/test-init

==============================================
2 of 9 tests failed
Please report to linux-modules@vger.kernel.org
==============================================

'make rootfs' does not do anything but make distclean && configure && 
make && make check is clean for me.

   -- Bruce

