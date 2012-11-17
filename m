Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KQN2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:28:11 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61274 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:28:10 -0500
X-Nat-Received: from [202.181.97.72]:61543 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353158866.8441
To: dhowells@redhat.com
Cc: arnd@arndb.de, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: [3.7-rc6] Build failure with scripts/Makefile.headersinst
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 17 Nov 2012 22:27:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17112012 #8400019, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get build error which complains that include/uapi/asm-generic/auxvec.h is
missing although the file exists. I'm using gcc 3.3.5.
This bug seems to not happen with gcc 4.x.

# make
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
make[3]: `arch/x86/realmode/rm/realmode.bin' is up to date.
  CHK     include/generated/uapi/linux/version.h
make[2]: Nothing to be done for `all'.
make[2]: Nothing to be done for `relocs'.
/usr/src/all/linux/scripts/Makefile.headersinst:50: *** Missing UAPI file /usr/src/all/linux/include/uapi/asm-generic/auxvec.h.  Stop.
make[2]: *** [asm-generic] Error 2
make[1]: *** [headers_install] Error 2
make: *** [vmlinux] Error 2
# ls -l /usr/src/all/linux/include/uapi/asm-generic/auxvec.h
-rw-r--r--  1 root root 218 Oct 20 14:56 /usr/src/all/linux/include/uapi/asm-generic/auxvec.h

Linux 3.6 builds fine. I can't use "git bisect" until Linux 3.7-rc6 but
possibly caused by either commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into
the user header installation and checking" or commit 40f1d4c2 "UAPI: Remove the
objhdr-y export list".
