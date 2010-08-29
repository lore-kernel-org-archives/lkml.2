Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0H2R25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:28:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51458 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0H2R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SwYrUOA5SqQdEjAGojslcLa8cBxQnNxNgic/j0TlabTsVRM2ptilACK8g4MjL1AGkw
         ZtdPNzAS1/GwQroARqOb4Kiq/EKl0k3hnNU9YkA6LMmGxojtI5rt/APrNWIbSz2eT2jj
         qxm6Ko11KbLcxhbIcuvaAVTqTwPNKtELplM5c=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH 0/3] initramfs: cleanups
Date: Mon, 30 Aug 2010 02:28:45 +0900
Message-Id: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to cleanup init/initramfs code especially for syscall
invocation which produces many warnings from sparse because of address
space change. One possible solution would be eliminating such calls at all
and use internal kernel functions directly. But Al Viro mentions there's
a historical(?) reason not to do so. [1]

First two of this patchset wrap all of syscall invocations with kern_sys_*()
helper functions which does nasty address space conversions for you. This
idea was suggested by Arnd Bergmann. Last one tries to implement above idea
- calling internel functions directly - in favour of kernel config option
even though I'm not sure this is right thing. :-(

This patchset depends on my previous patch "init: mark __user address space
on string literals" [2] now contained in -mm tree.

Any comments would be welcomed.

Thanks.

[1] http://lkml.org/lkml/2010/8/20/202
[2] http://lkml.org/lkml/2010/8/18/157

---

Namhyung Kim (3):
  init: add sys-wrapper.h
  initramfs: use kern_sys_* macros instead of syscall
  init: introduce CONFIG_USE_INIT_SYSCALL_AS_KERNEL_ROUTINE

 init/Makefile      |    2 +
 init/sys-wrapper.c |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/sys-wrapper.h |  305 +++++++++++++++++++++++++++
 usr/Kconfig        |    7 +
 4 files changed, 903 insertions(+), 0 deletions(-)
 create mode 100644 init/sys-wrapper.c
 create mode 100644 init/sys-wrapper.h

--
1.7.2.2

