Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0HaPae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:30:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46244 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0HaPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eVrhjZIJvWGHBYNriJVS0A0m7mlxnb5NyDyfRke2zKfwoJOda6i5R9cdtdEUS3nbyK
         IkzLzHKc5NlCLngz1w+r/04BELp6RjNcH247HKolWbFlsk1xcPRwe4INXwrlgVRzZB20
         lUncAajstTHvI1KbhE+nKS9gCdQ7M0rxl9YTo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] init cleanups
Date: Wed,  1 Sep 2010 00:30:17 +0900
Message-Id: <1283268619-10728-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to cleanup init/initramfs code especially for syscall
invocation which produces many warnings from sparse because of address
space change. This can be done by wrapping each syscall invocation and
doing such conversions in it using kernel_sys_call() macro suggested by
Arnd Bergmann.

This patchset depends on my previous patch "init: mark __user address space
on string literals" [1] now contained in -mm tree. Actually now it can be
replaced by these patches. Andrew, I can respin this if you want to remove
my previous one in -mm tree.

Any comments would be welcomed.

Thanks.

[1] http://lkml.org/lkml/2010/8/18/157


---

* changes from v3:
  make inverse christmas tree of headers :-)
  macro name prefix is changed to 'kernel_sys_'
  update some comments

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
 init/do_mounts_initrd.c |   48 ++++++-----
 init/do_mounts_md.c     |   29 +++---
 init/do_mounts_rd.c     |   39 +++++----
 init/initramfs.c        |   64 +++++++-------
 init/main.c             |   12 ++-
 init/noinitramfs.c      |   12 ++-
 init/sys-wrapper.h      |  216 +++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 338 insertions(+), 111 deletions(-)
 create mode 100644 init/sys-wrapper.h

--
1.7.2.2

