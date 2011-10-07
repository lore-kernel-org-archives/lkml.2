Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab1JGSwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:52:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1JGSwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:52:46 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=5E__mjtSOyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=g9ZA9j1XRvxJFiV1iagA:9 a=jSg2Qn4Y7NbMdUMkT0wA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] kbuild: let object files depend on recordmcount instead
 of its sources
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Fri, 07 Oct 2011 14:52:44 -0400
In-Reply-To: <20111007180415.GW6949@pengutronix.de>
References: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1318005094.4729.40.camel@gandalf.stny.rr.com>
	 <20111007180415.GW6949@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 8bit
Message-ID: <1318013565.4729.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 20:04 +0200, Uwe Kleine-König wrote:

> Works for me with 3ee72ca + my patch doing:
> 
> 	make -C /path/to/my/linux/src/dir defconfig O=$(pwd)
> 	make -j 6
> 
> If you tell me your exact setup I'll try to reproduce and fix.

I just tried again with the same results. Here:

$ cd git
$ git clone nobackup/linus.git -s -l tmp.git
Cloning into tmp.git...
done.
$ cd tmp.git/
$ mkdir /tmp/build
$ patch -p1 < /tmp/rm.patch
patching file scripts/Makefile.build
$ make O=/tmp/build allyesconfig
  HOSTCC  scripts/basic/fixdep
  GEN     /tmp/build/Makefile
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allyesconfig Kconfig
#
# configuration written to .config
#
$ make O=/tmp/build
  GEN     /tmp/build/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
/home/pub/git/tmp.git/arch/x86/Makefile:81: stack protector enabled but
no compiler support
  Using /home/pub/git/tmp.git as source for kernel
  GEN     /tmp/build/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/pub/git/tmp.git/scripts/checksyscalls.sh
  HOSTCC  scripts/genksyms/genksyms.o
  SHIPPED scripts/genksyms/lex.lex.c
  SHIPPED scripts/genksyms/keywords.hash.c
  SHIPPED scripts/genksyms/parse.tab.h
  HOSTCC  scripts/genksyms/lex.lex.o
  SHIPPED scripts/genksyms/parse.tab.c
  HOSTCC  scripts/genksyms/parse.tab.o
  HOSTLD  scripts/genksyms/genksyms
make[3]: *** No rule to make target `scripts/mod/empty.o', needed by
`scripts/mod/elfconfig.h'.  Stop.
make[2]: *** [scripts/mod] Error 2
make[1]: *** [scripts] Error 2
make: *** [sub-make] Error 2


It needs to be a real clean repo, not a make clean.

-- Steve


