Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0FURRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:17:07 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:38040 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0FURRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:17:05 -0400
Date: Mon, 21 Jun 2010 12:16:58 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <alpine.DEB.2.00.1006211155540.7407@router.home>
Message-ID: <alpine.DEB.2.00.1006211209520.7407@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <4C1CA49B.7020104@colorfullife.com> <alpine.DEB.2.00.1006211155540.7407@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more information that may be helpful:

proc/27878$ strace -p 27878
Process 27878 attached - interrupt to quit
semop(65536, {{0, -1, SEM_UNDO}}, 1

proc/27878$ ps xawwwww_
ERROR: Unsupported option (BSD syntax)

ps alx shows a number of stuck processes:

0  1000 20121 17784  20   0 367040 14416 poll_s Sl   ?          0:07 /usr/lib/chromium-browser/chromium-browser --type=plugin --plugin-path=/var/lib/flashplugin-installer/npwr
0  1000 23477 20121  20   0 120864 19940 poll_s Sl   ?          0:07 /usr/lib/nspluginwrapper/i386/linux/npviewer.bin --plugin /usr/lib/flashplugin-installer/libflashplayer.so
0  1000 23531 16635  20   0  13928  2292 wait   S+   pts/0      0:00 /usr/bin/make -j9 EXTRAVERSION=-rc3-broke ARCH=x86_64 modules
0  1000 24724 23531  20   0  17220  5444 wait   S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=fs
0  1000 24817 23531  20   0  13512  1928 pipe_w S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers
0  1000 25374 23531  20   0  14256  2384 pipe_w S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=net
0  1000 27275 24817  20   0  13252  1560 wait   S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/media
0  1000 27294 27275  20   0  13272  1576 pipe_w S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/media/dvb
0  1000 27623 27275  20   0  20720  8980 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/media/video
0  1000 27633 25374  20   0  16696  4984 pipe_w S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=net/sunrpc
0  1000 27691 24724  20   0  18400  6700 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=fs/xfs
0  1000 27693 27294  20   0  18252  6504 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/media/dvb/frontends
0  1000 27743 25374  20   0  15988  4244 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=net/tipc
0  1000 27744 24817  20   0  15016  3268 pipe_w S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/misc
0  1000 27754 25374  20   0  14832  3008 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=net/wimax
0  1000 27769 27633  20   0  14816  2836 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=net/sunrpc/auth_gss
0  1000 27839 27744  20   0  13932  2100 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/misc/c2port
0  1000 27847 27744  20   0  13996  2224 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/misc/cb710
0  1000 27866 27744  20   0  13772  1844 semtim S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/misc/eeprom
0  1000 27877 27693  20   0      0     0 exit   Z+   pts/0      0:00 [sh] <defunct>
0  1000 27878 27623  20   0   8292   352 semtim S+   pts/0      0:00 /bin/sh -c { echo drivers/media/video/zr364xx.ko; echo drivers/media/video/zr364xx.o; } > .tmp_versions/zr1  1000 27879  2140  20   0  20900  4000 wait   S+   pts/1      0:00 bash
0  1000 27905  2097  20   0  20900  4972 wait   Ss   pts/3      0:00 bash
0  1000 27997 27905  20   0   6588   756 -      R+   pts/3      0:00 ps alx


