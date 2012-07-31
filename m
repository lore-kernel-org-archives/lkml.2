Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2GaTRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab2GaTRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:17:36 -0400
Date: Tue, 31 Jul 2012 15:17:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, oleg@redhat.com
Subject: post 3.5, phantom signals.
Message-ID: <20120731191731.GB30493@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, oleg@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.5, I've started noticing weird things happening with signal delivery.
Things I've seen so far..

- long running tasks SIGINT, even though I wasn't even anywhere near the keyboard.
- processes running inside screen/tmux disappearing (and taking the whole session with them).

And now, while waiting for a kernel to build I just saw..

/bin/sh: line 1:  3274 Hangup                  gcc
-Wp,-MD,net/netfilter/.xt_HL.o.d -nostdinc -isystem
/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include
-I/home/davej/src/linux-dj/arch/x86/include -Iarch/x86/include/generated
-Iinclude -include /home/davej/src/linux-dj/include/linux/kconfig.h
-D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-Wno-format-security -fno-delete-null-pointer-checks -O2 -m64
-mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time
-maccumulate-outgoing-args -fstack-protector -DCONFIG_X86_X32_ABI
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
-DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_AVX=1 -pipe
-Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx
-mno-sse2 -mno-3dnow -mno-avx -Wframe-larger-than=2048
-Wno-unused-but-set-variable -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack
-DCC_HAVE_ASM_GOTO -DMODULE -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(xt_HL)"
-D"KBUILD_MODNAME=KBUILD_STR(xt_HL)" -c -o net/netfilter/xt_HL.o
net/netfilter/xt_HL.c

Any thoughts on specific commits that might be guilty ?

	Dave

