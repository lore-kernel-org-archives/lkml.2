Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2CSWbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:31:49 -0400
Received: from out.selfhost.de ([82.98.82.95]:33981 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757766Ab2CSWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:31:42 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 18:31:42 EDT
Message-ID: <4F67B23B.7010209@afaics.de>
Date: Mon, 19 Mar 2012 23:24:59 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3: 2nd build fails with asm/unistd_64.h: No such file or directory
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

If I build 3.3 _again_ from the same source tree, then I get a problem
about a missing asm/unistd_64.h. Here is a sample session:


% make -C /export/git/linux-source O=/export/tmp/build_kernel/build clean
make: Entering directory `/export/git/linux-source'
  CLEAN   .
  CLEAN   .tmp_versions
make: Leaving directory `/export/git/linux-source'
% make -C /export/git/linux-source clean
make: Entering directory `/export/git/linux-source'
make: Leaving directory `/export/git/linux-source'
% make -C /export/git/linux-source O=/export/tmp/build_kernel/build oldconfig
make: Entering directory `/export/git/linux-source'
  HOSTCC  scripts/basic/fixdep
  GEN     /export/tmp/build_kernel/build/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#
make: Leaving directory `/export/git/linux-source'
% make -C /export/git/linux-source O=/export/tmp/build_kernel/build
make: Entering directory `/export/git/linux-source'
  GEN     /export/tmp/build_kernel/build/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
make[2]: Nothing to be done for `all'.
  Using /export/git/linux-source as source for kernel
  GEN     /export/tmp/build_kernel/build/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from /export/git/linux-source/include/linux/unistd.h:7:0,
                 from /export/git/linux-source/arch/x86/include/asm/seccomp_64.h:4,
                 from /export/git/linux-source/arch/x86/include/asm/seccomp.h:4,
                 from /export/git/linux-source/include/linux/seccomp.h:8,
                 from /export/git/linux-source/include/linux/sched.h:80,
                 from /export/git/linux-source/arch/x86/kernel/asm-offsets.c:9:
/export/git/linux-source/arch/x86/include/asm/unistd.h:16:29: fatal error: asm/unistd_64.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/export/git/linux-source'




AFAICS asm/unistd_64.h was generated in the source directory, even
though I explicitly specified a separate build directory. Is this
expected?

There was no such problem for 3.2.12 and older. "git clean -dfx"
seems to help.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9nsjsACgkQUTlbRTxpHjc9ewCfXBfOXhT0Zh89r6N8upv3Dwur
CnAAn1U9qho/XJWO1h5D1NBMXIsBq+Jp
=CJLY
-----END PGP SIGNATURE-----
