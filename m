Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2GTUYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:24:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63781 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2GTUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:24:37 -0400
MIME-Version: 1.0
Date: Sat, 21 Jul 2012 01:54:36 +0530
Message-ID: <CAF+rN0S5VZ+2fEjacXmtcdU2U1cjJg+EJP4xGAKKX2WFFMXL7g@mail.gmail.com>
Subject: vfork() / clone() with pthreads / setuid
From: Vishal K <linuxkernelrocks@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel experts,

>From http://developers.sun.com/solaris/articles/subprocess/subprocess.html
, I am curious to know if the following is already addressed in linux
kernel for vfork() / clone() calls.

The vfork(2) system call was also adopted in the Solaris OS. Much
later, however, when multithreading (MT) became available and widely
used it was discovered that vfork() may introduce a new problem when
the application has multiple threads running: deadlock. The deadlock
can happen due to the dynamic linker ld.so.1 involvement in resolving
the necessary symbols. Particularly, if the child process calls an
external function (such as exec()), the dynamic linker may be invoked
to resolve the Procedure Linkage Table (PLT) entry, for which the
dynamic linker will acquire a mutex lock. This lock may already be
held by a different thread in the parent process. If this happens it
will create a deadlock between the parent and child processes, because
no thread in the parent can run until the child has called exec() or
exit(). As a result, both the parent and the child processes will
hang.


Also, is it allowed to call setuid() after a vfork() or a clone()
before doing execv() so that the executed command can be run as a
different user?


I realize this may not be the right forum for such queries, but looks
like this is not available anywhere.

Regards,
Kernel Rocks.
