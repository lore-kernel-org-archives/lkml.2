Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1JGSEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:04:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43320 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1JGSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:04:18 -0400
Date: Fri, 7 Oct 2011 20:04:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: let object files depend on recordmcount instead
 of its sources
Message-ID: <20111007180415.GW6949@pengutronix.de>
References: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1318005094.4729.40.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1318005094.4729.40.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:31:33PM -0400, Steven Rostedt wrote:
> On Fri, 2011-10-07 at 15:19 +0200, Uwe Kleine-König wrote:
> > This has the upside that distributions only have to ship the recordmcount
> > binary to allow building modules instead of recordmcount and it's sources.
> > 
> > Make still notices that the object files need to be rebuilt when
> > recordmcount's sources change.
> 
> This doesn't work. Try it on a clean build:
> 
>   HOSTCC  scripts/basic/fixdep
>   GEN     /home/rostedt/work/git/tmp/Makefile
>   HOSTCC  scripts/kconfig/conf.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/lex.zconf.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf --silentoldconfig Kconfig
>   Using /home/rostedt/work/git/linux-rt.git as source for kernel
>   GEN     /home/rostedt/work/git/tmp/Makefile
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/generated/asm-offsets.h
>   CALL    /home/rostedt/work/git/linux-rt.git/scripts/checksyscalls.sh
> make[3]: *** No rule to make target `scripts/mod/empty.o', needed by `scripts/mod/elfconfig.h'.  Stop.
> make[2]: *** [scripts/mod] Error 2
> make[1]: *** [scripts] Error 2
> make: *** [sub-make] Error 2
Works for me with 3ee72ca + my patch doing:

	make -C /path/to/my/linux/src/dir defconfig O=$(pwd)
	make -j 6

If you tell me your exact setup I'll try to reproduce and fix.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
