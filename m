Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1CJQuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:50:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40450 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1CJQuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=Y/ifN5Jysmwul+RwPMlMCPwu6C2u14kfamYv3dn8nNYlERqM6drarRLqLgof/LOUum
         hk+Weswc4nc1fEQoK1CdyE9AqTWMRKYoQ7XYjCR/SXdZH5budlnca1HNaTMc68YHaGw8
         SMyd6R8laMPUsN35i80H24zrwQ2rXYncGY4dA=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <4CA1E809.5010103@tilera.com>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Thu, 10 Mar 2011 10:46:00 -0600
Message-ID: <AANLkTikRvGO_xrk85eegh_PeGrkOOkpN-rjkhJCW7n74@mail.gmail.com>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

A question, and a patch follow:

On 28 September 2010 08:05, Chris Metcalf <cmetcalf@tilera.com> wrote:
>  (Adding libc-ports to the cc list.)
>
> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
>> Chris Metcalf is using the generic unistd.h file on the tile architecture
>> and has a glibc port that should be easily portable to all future
>> architectures. There are a few of them getting ready to be merged
>> now (c6x, lm32, nios2, and some people have contacted me privately
>> for architectures I cannot name).
>>
>> I expect that all of them will just use the same syscall ABI and glibc
>> port.
>
> I'm happy to provide some previews of the work I'm doing to interested parties.
[...]

> sysdeps/unix/sysv/linux/generic/access.c
> sysdeps/unix/sysv/linux/generic/bits/fcntl.h
> sysdeps/unix/sysv/linux/generic/bits/sem.h
> sysdeps/unix/sysv/linux/generic/bits/stat.h
> sysdeps/unix/sysv/linux/generic/bits/typesizes.h
> sysdeps/unix/sysv/linux/generic/chmod.c
> sysdeps/unix/sysv/linux/generic/chown.c
> sysdeps/unix/sysv/linux/generic/lxstat.c
> sysdeps/unix/sysv/linux/generic/xstat.c
> sysdeps/unix/sysv/linux/generic/Versions
> sysdeps/unix/sysv/linux/generic/fxstatat.c
> sysdeps/unix/sysv/linux/generic/lchown.c
> sysdeps/unix/sysv/linux/generic/link.c
> sysdeps/unix/sysv/linux/generic/readlink.c
> sysdeps/unix/sysv/linux/generic/open.c
> sysdeps/unix/sysv/linux/generic/open64.c
> sysdeps/unix/sysv/linux/generic/pipe.c
> sysdeps/unix/sysv/linux/generic/poll.c
> sysdeps/unix/sysv/linux/generic/recv.c
> sysdeps/unix/sysv/linux/generic/rmdir.c
> sysdeps/unix/sysv/linux/generic/send.c
> sysdeps/unix/sysv/linux/generic/symlink.c
> sysdeps/unix/sysv/linux/generic/syscalls.list
> sysdeps/unix/sysv/linux/generic/sysdep.h
> sysdeps/unix/sysv/linux/generic/unlink.c
> sysdeps/unix/sysv/linux/generic/xmknod.c
> sysdeps/unix/sysv/linux/generic/sysctl.c
> sysdeps/unix/sysv/linux/generic/readlink_chk.c
> sysdeps/unix/sysv/linux/generic/ustat.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/fcntl.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/fstatfs.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/ftruncate.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/fxstat.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/llseek.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/lseek.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/mmap.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/posix_fadvise.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/sendfile.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/statfs.c
> sysdeps/unix/sysv/linux/generic/wordsize-32/truncate.c
> sysdeps/unix/sysv/linux/generic/brk.c
> sysdeps/unix/sysv/linux/generic/dl-origin.c
> sysdeps/unix/sysv/linux/generic/umount.c
> sysdeps/unix/sysv/linux/generic/creat.c
> sysdeps/unix/sysv/linux/generic/pause.c
> sysdeps/unix/sysv/linux/generic/Makefile
> sysdeps/unix/sysv/linux/generic/select.c
> sysdeps/unix/sysv/linux/generic/epoll_create.c
> sysdeps/unix/sysv/linux/generic/epoll_wait.c
> sysdeps/unix/sysv/linux/generic/inotify_init.c
> sysdeps/unix/sysv/linux/generic/dup2.c
> sysdeps/unix/sysv/linux/generic/mkdir.c
> sysdeps/unix/sysv/linux/generic/rename.c
> sysdeps/unix/sysv/linux/generic/utimes.c

I note that this hasn't been merged into glibc-2.13, any particular
explaintation
for that?

Anyway, it seems that pthread cancellation pints are missing
from a couple of the functions.  e.g. for send, recv, one needs
the following:

Index: glibc-2.13/sysdeps/unix/sysv/linux/generic/send.c
===================================================================
--- glibc-2.13.orig/sysdeps/unix/sysv/linux/generic/send.c	2011-03-10
10:26:48.000000000 -0600
+++ glibc-2.13/sysdeps/unix/sysv/linux/generic/send.c	2011-03-10
10:26:55.000000000 -0600
@@ -18,12 +18,25 @@

 #include <stdlib.h>
 #include <sys/types.h>
-#include <sysdep.h>
+#include <sysdep-cancel.h>
 #include <libc-symbols.h>

 ssize_t __libc_send(int sockfd, const void *buffer, size_t len, int flags)
 {
-  return INLINE_SYSCALL (sendto, 6, sockfd, buffer, len, flags, NULL, 0);
+  ssize_t result;
+
+  if (SINGLE_THREAD_P)
+    result = INLINE_SYSCALL (sendto, 6, sockfd, buffer, len, flags, NULL, 0);
+  else
+    {
+      int oldtype = LIBC_CANCEL_ASYNC ();
+
+      result = INLINE_SYSCALL (sendto, 6, sockfd, buffer, len, flags, NULL, 0);
+
+      LIBC_CANCEL_RESET (oldtype);
+    }
+
+  return result;
 }

 strong_alias (__libc_send, __send)

and likewise for recv ...

--linas
