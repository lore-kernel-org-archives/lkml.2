Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0INOSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:18:30 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56545 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0INOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:18:26 -0400
Date: Tue, 14 Sep 2010 16:18:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100914141818.GD2201@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <4C8EE708.5000109@codeaurora.org>
 <20100914082506.GA2201@osiris.boeblingen.de.ibm.com>
 <201009141510.43446.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009141510.43446.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:10:43PM +0200, Arnd Bergmann wrote:
> On Tuesday 14 September 2010, Heiko Carstens wrote:
> > On Mon, Sep 13, 2010 at 08:07:52PM -0700, Stephen Boyd wrote:
> > > Changing the buf_size variable from an int to a size_t makes the warning
> > > go away. Perhaps this is because gcc can't reliably eliminate the else
> > > case when the lower bound isn't 0? Overflow? I'm not really sure. Does
> > > the kernel/kprobes.c part of this patch work for you?
> > 
> > Yes, the warning goes away on s390 as well.
> 
> Ok, great!
> 
> In that case, I think we should just apply this patch to fix all these
> warnings for good. There are probably some more in an x86_64 allyesconfig
> build, but this should make s390 build cleanly again.

Nah, that would be too easy.
allyesconfig with gcc 4.5.2 and both patches applied:

In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from net/core/pktgen.c:123:
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:881:20:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1144:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1251:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1273:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1297:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1320:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1343:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1364:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1385:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1406:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1433:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1469:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from net/core/pktgen.c:123:
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1793:20:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1824:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from drivers/net/tun.c:42:
In function 'copy_from_user',
    inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1200:21:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/sysdev.h:25,
                 from include/linux/cpu.h:22,
                 from kernel/perf_event.c:14:
In function 'copy_from_user',
    inlined from 'perf_copy_attr' at kernel/perf_event.c:5006:22,
    inlined from 'SYSC_perf_event_open' at kernel/perf_event.c:5110:6,
    inlined from 'SyS_perf_event_open' at kernel/perf_event.c:5095:1:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from drivers/scsi/sg.c:31:
In function 'copy_from_user',
    inlined from 'sg_proc_write_adio' at drivers/scsi/sg.c:2373:20:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13:0,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/icmpv6.h:82,
                 from net/compat.c:19:
In function 'copy_from_user',
    inlined from 'compat_sys_socketcall' at net/compat.c:783:20:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:297:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
