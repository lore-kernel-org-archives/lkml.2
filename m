Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965722Ab2JWXSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:18:53 -0400
Received: from honeysuckle.london.02.net ([87.194.255.144]:59025 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2JWXSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:18:51 -0400
From: Matthew Leach <matthew@mattleach.net>
To: linux-kernel@vger.kernel.org
Cc: Martin =?utf-8?Q?P=C3=A4rtel?= <martin.partel@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [REGRESSION] uml: signal.c build errors
Date: Wed, 24 Oct 2012 00:18:34 +0100
Message-ID: <87pq48lqut.fsf@mattleach.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When building UML against 3.7-rc2 I encounter the following build error:

# make ARCH=uml
scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
  CHK     include/generated/uapi/linux/version.h
  UPD     include/generated/uapi/linux/version.h
  WRAP    arch/um/include/generated/asm/clkdev.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h

...

  CC      arch/um/os-Linux/signal.o
arch/um/os-Linux/signal.c:18:8: error: conflicting types for ‘sig_info’
In file included from arch/um/os-Linux/signal.c:12:0:
/home/matthew/Development/linux/arch/um/include/shared/as-layout.h:64:15: note: previous declaration of ‘sig_info’ was here
arch/um/os-Linux/signal.c:19:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:19:2: warning: (near initialization for ‘sig_info[5]’) [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: (near initialization for ‘sig_info[8]’) [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: (near initialization for ‘sig_info[4]’) [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: (near initialization for ‘sig_info[28]’) [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: (near initialization for ‘sig_info[7]’) [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: (near initialization for ‘sig_info[11]’) [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: (near initialization for ‘sig_info[29]’) [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: (near initialization for ‘sig_info[26]’) [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: (near initialization for ‘handlers[26]’) [enabled by default]
make[1]: *** [arch/um/os-Linux/signal.o] Error 1
make: *** [arch/um/os-Linux] Error 2

I have tracked this down to [1] where, indeed, the type of sig_info is
different; the second parameter in signal.c is 'siginfo_t' where as in
as-layout.h the second parameter's type is declared as 'struct siginfo'.

[1]: d3c1cfcdb43e023ab1b1c7a555cd9e929026500a

Matt
