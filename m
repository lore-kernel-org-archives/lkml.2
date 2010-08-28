Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0H1HlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 03:41:14 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:39407 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0H1HlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 03:41:13 -0400
Date: Sat, 28 Aug 2010 09:43:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100828074304.GA2183@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <201008251414.16411.arnd@arndb.de>
 <20100825125451.GH2153@osiris.boeblingen.de.ibm.com>
 <201008251555.53653.arnd@arndb.de>
 <20100825144040.GI2153@osiris.boeblingen.de.ibm.com>
 <4C7867D4.10404@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7867D4.10404@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 06:35:16PM -0700, Stephen Boyd wrote:
> On 08/25/2010 07:40 AM, Heiko Carstens wrote:
> > On Wed, Aug 25, 2010 at 03:55:53PM +0200, Arnd Bergmann wrote:
> >>
> >> If you don't want to see the warnings, then just remove the strict checks.
> >> We already concluded that there is little value in them on s390 since it only
> >> shows false postives.
> >>
> >> Maybe the easiest way would be to rename the option on s390 and move all
> >> the other ones into a common place.
> > 
> > Yes, feel free to do that.
> 
> Can you put up the false positives somewhere? I don't have easy access
> to an s390 toolchain to test build with and I'm interested to see how
> bad the false positives are.
> 
> I'm slightly concerned that we'll just have this problem again when
> another arch comes along with false positives. But ignoring that issue
> is probably fine. I'll respin with a patch to move s390 to something
> like DEBUG_WARN_USER_COPY_CHECKS.

Sure:

In function 'copy_from_user',
    inlined from 'write_enabled_file_bool' at kernel/kprobes.c:1973:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'perf_copy_attr' at kernel/perf_event.c:4988,
    inlined from 'SYSC_perf_event_open' at kernel/perf_event.c:5092,
    inlined from 'SyS_perf_event_open' at kernel/perf_event.c:5077:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1200:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:880:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1143:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1250:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1272:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1296:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1319:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1342:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1363:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1384:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1405:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1432:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1468:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1792:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1823:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'write_file_bool' at fs/debugfs/file.c:434:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'sg_proc_write_dressz' at drivers/scsi/sg.c:2396:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'sg_proc_write_adio' at drivers/scsi/sg.c:2373:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'packet_getsockopt' at net/packet/af_packet.c:2123:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'compat_sys_socketcall' at net/compat.c:783:
/linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
