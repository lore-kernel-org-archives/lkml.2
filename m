Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2JHNmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:42:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37693 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2JHNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <505695E3.7040603@gmail.com>
References: <CAMOw1v6MYW6O2f4AR9yRvh200j5R6mFTRqDT3TFbG-TjknmUmw@mail.gmail.com>
 <alpine.LNX.2.01.1209170427220.6182@nerf07.vanv.qr> <505695E3.7040603@gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Mon, 8 Oct 2012 10:41:37 -0300
Message-ID: <CAKi4VAKt_TxM1mZ5aczL=e4jd1EGmr4bgTWfrX5nN+-z3YiWCA@mail.gmail.com>
Subject: Re: [ANNOUNCE] kmod 10
To: Bruce Dubbs <bruce.dubbs@gmail.com>
Cc: Jan Engelhardt <jengelh@inai.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:15 AM, Bruce Dubbs <bruce.dubbs@gmail.com> wrote:
> Jan Engelhardt wrote:
>>
>>
>> On Thursday 2012-09-06 21:37, Lucas De Marchi wrote:
>>>
>>>
>>> kmod 10 is out:
>>>
>>> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.xz
>>> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.sign
>>
>>
>> make check fails here with glibc-2.15, gcc-4.7, x86_64,
>> due to what seems to be duplicated symbols(?)
>
>
> On my LFS system, glibc-2.16, gcc-4.7.1, x86_64, I do not see these errors:
>
> ./configure --prefix=/usr --bindir=/bin --libdir=/lib \
>             --sysconfdir=/etc --with-xz --with-zlib
> make
> make check
>
> ==================
> All 9 tests passed
> ==================
>
> What is interesting is that if I run the checks again:
>
> make check
>
> I get:
>
> TESTSUITE: running modprobe_softdep_loop, in forked context
> TESTSUITE: ERR: rootfs
> /usr/src/kmod/kmod-10/testsuite/rootfs/test-modprobe/softdep-loop is dirty,
> please run 'make rootfs' before runnning this test
> TESTSUITE: ERR: 'modprobe_softdep_loop' [16407] exited with return code 1
> TESTSUITE: ERR: FAILED: modprobe_softdep_loop
> FAIL: testsuite/test-modprobe
>
> TESTSUITE: running test_insert, in forked context
> TESTSUITE: ERR: rootfs /usr/src/kmod/kmod-10/testsuite/rootfs/test-init/ is
> dirty, please run 'make rootfs' before runnning this test
> TESTSUITE: ERR: 'test_insert' [16373] exited with return code 1
> TESTSUITE: ERR: FAILED: test_insert
> FAIL: testsuite/test-init
>
> ==============================================
> 2 of 9 tests failed
> Please report to linux-modules@vger.kernel.org
> ==============================================
>
> 'make rootfs' does not do anything but make distclean && configure && make
> && make check is clean for me.

"make rootfs" was completely wrong, it's fixed now and queued for kmod 11:
http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=commit;h=84afccb91db106ad81effc88c2851ceddeda06ea

and

http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=commit;h=cf814054dd9a1f5240bc684769275e40ab81ba6e



Lucas De Marchi
