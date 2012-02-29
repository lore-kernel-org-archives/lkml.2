Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894Ab2B2TFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:05:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59306 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2B2TFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:05:41 -0500
Date: Wed, 29 Feb 2012 11:01:38 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: `make dep' with clock skew detected loops forever
Message-ID: <20120229190138.GG5136@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 3.0.0-16-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022919-2398-0000-0000-000004A8BC73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed something on a fresh FC16 based install on a test server in our
lab.  Autotest by default runs `make dep` and it seems the clock is
pretty badly skewed on this server, resulting in an infinite loop of:

01:09:37 DEBUG| Running 'make dep'
01:09:38 DEBUG| [stderr] make: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
01:09:38 DEBUG| [stderr] make[1]: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
01:09:38 DEBUG| [stdout]   HOSTCC  scripts/basic/fixdep
01:09:38 DEBUG| [stderr] make[2]: warning:  Clock skew detected.  Your build may be incomplete.
01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
01:09:38 DEBUG| [stdout]   HOSTCC  scripts/kconfig/conf.o
01:09:38 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.tab.c
01:09:38 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.lex.c
01:09:38 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.hash.c
01:09:39 DEBUG| [stdout]   HOSTCC  scripts/kconfig/zconf.tab.o
01:09:39 DEBUG| [stdout]   HOSTLD  scripts/kconfig/conf
01:09:39 DEBUG| [stdout] scripts/kconfig/conf --silentoldconfig Kconfig
01:09:39 DEBUG| [stderr] make[2]: warning:  Clock skew detected.  Your build may be incomplete.
01:09:39 DEBUG| [stderr] make[1]: warning:  Clock skew detected.  Your build may be incomplete.
01:09:39 DEBUG| [stderr] make: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112142 s in the future
01:09:39 DEBUG| [stderr] make[1]: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112142 s in the future
01:09:39 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112142 s in the future
01:09:39 DEBUG| [stdout]   HOSTCC  scripts/basic/fixdep
01:09:40 DEBUG| [stderr] make[2]: warning:  Clock skew detected.  Your build may be incomplete.
01:09:40 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112141 s in the future
01:09:40 DEBUG| [stdout]   HOSTCC  scripts/kconfig/conf.o
01:09:40 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.tab.c
01:09:40 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.lex.c
01:09:40 DEBUG| [stdout]   SHIPPED scripts/kconfig/zconf.hash.c
01:09:40 DEBUG| [stdout]   HOSTCC  scripts/kconfig/zconf.tab.o
01:09:40 DEBUG| [stdout]   HOSTLD  scripts/kconfig/conf
01:09:40 DEBUG| [stdout] scripts/kconfig/conf --silentoldconfig Kconfig

Anyone know why that happens? Obvious fixes are to either not run `make
dep` or to install an NTP client, and I can do that, but figured I'd
report the above.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

