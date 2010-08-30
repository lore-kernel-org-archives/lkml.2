Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0H3R2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:28:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53188 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0H3R2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vdJb2R05+6JKP+7Q83Nbx50yPtQwPm+OQezf8W320Y+A0FetH0S/25dJwktZkR6V+p
         V7Q+dFL9IZY+u6elYiYQAPaBaXNV+gKPUH+YKoGC8Fd5T08kDE11GFaFuUlJevNcfdUu
         whCPLKX/gFma2JugoaaTI5+a4N3jOBAbatJXE=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] init cleanups
Date: Tue, 31 Aug 2010 02:27:48 +0900
Message-Id: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to cleanup init/initramfs code especially for syscall
invocation which produces many warnings from sparse because of address
space change. This can be done by wrapping each syscall invocation and
doing such conversions in it using kern_sys_call() macro suggested by
Arnd Bergmann.

This patchset depends on my previous patch "init: mark __user address space
on string literals" [1] now contained in -mm tree.

Any comments would be welcomed.

Thanks.

[1] http://lkml.org/lkml/2010/8/18/157


---

* changes from v2:
  use kern_sys_call() macro only on functions have pointer argument
  config option to use low-level VFS code removed
  apply to all init/*.c not only initramfs code

* changes from v1:
  introduce kern_sys_* wrappers instead of adding __force markups
  config option to use low-level VFS code added


Namhyung Kim (2):
  init: add sys-wrapper.h
  init: use kern_sys_* wrappers instead of syscall

 init/do_mounts.c        |   29 +++---
 init/do_mounts_initrd.c |   48 +++++-----
 init/do_mounts_md.c     |   29 +++---
 init/do_mounts_rd.c     |   37 ++++----
 init/initramfs.c        |   61 +++++++------
 init/main.c             |    9 +-
 init/noinitramfs.c      |   10 +-
 init/sys-wrapper.h      |  230 +++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 345 insertions(+), 108 deletions(-)
 create mode 100644 init/sys-wrapper.h

--
1.7.2.2

