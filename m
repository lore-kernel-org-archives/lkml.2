Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0I0X0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:26:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53884 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0I0X0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=pZ5UXvxABRBgTKmu7IQF3eQ4mwZnhpj6j3QlgR3Y3zRjc9D49e+Xqn/h30zrl3M2U/
         w1ImU9uP0fxINmpe5+7Hw/+YOvrtLB2g0eYmHQYbBnFaMrkbWP1W3Zr12l7bGVXcNJ8k
         4vUYegfbvutnC1mf2M0AQbeA2N3YhZByiASTI=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Mon, 27 Sep 2010 18:26:29 -0500
Message-ID: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
Subject: asm-generic/unistd.h and glibc use of NR_ipc
To: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to figure out the status of glibc w.r.t the latest linux
unistd syscall interface, specifically, the status of the NR_ipc
syscall.   Currently, I see the following:

-- Circa June 2009, Arnd Bergman introduced asm-generic/unistd.h
(into the linux kernel) to provide a generic interface to system
calls. It does *not* define NR_ipc, and instead provides
NR_msgsnd, msgrcv, msgget, msgctl etc. syscalls.

-- Current glibc (2.12.1, as well as the current eglibc) does
not appear to use these new calls anywhere. Instead, glibc
has generic (non-arch-specific) implementations of msgsnd
etc.  that use the old NR_ipc interface (see, e.g.
sysdeps/unix/sysv/linux/msgsnd.c, semget.c, shmdt.c, msgrcv.c,
shmget.c, etc.)

Is someone working on patches to get glibc to use the new
syscall interfaces (for IPC)?  Am I missing something? Seems like
any arch wishing to use asm-generic/unistd.h and get glibc working
gets to break new ground, here ... right?

-- Linas
