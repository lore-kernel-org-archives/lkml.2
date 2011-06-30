Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1F3Tgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:36:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997Ab1F3Tgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:36:49 -0400
Date: Thu, 30 Jun 2011 12:36:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
Message-Id: <20110630123616.dc17cfa9.akpm@linux-foundation.org>
In-Reply-To: <4E0CCD4C.1090801@codeaurora.org>
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
	<1306865673-20560-4-git-send-email-sboyd@codeaurora.org>
	<20110630121909.d4ac1bfc.akpm@linux-foundation.org>
	<4E0CCD4C.1090801@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 12:23:56 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 06/30/2011 12:19 PM, Andrew Morton wrote:
> > On Tue, 31 May 2011 11:14:32 -0700
> > Stephen Boyd <sboyd@codeaurora.org> wrote:
> >
> >> Strict user copy checks are only really supported on x86_32 even
> >> though the config option is selectable on x86_64. Add the
> >> necessary support to the 64 bit code to trigger copy_from_user()
> >> warnings at compile time.
> >
> > So I'm getting 20-30 warnings from an x86_64 allmodconfig build.
> >
> > I don't think we want a million other people to have to put up with
> > those warnings too.  Can you please take a look at fixing these up?
> >
> 
> Care to share the warnings? I'll run a build again and fix any new
> warnings I find.


init/calibrate.c: In function 'calibrate_delay':
init/calibrate.c:251: warning: 'lpj' may be used uninitialized in this function
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:70,
                 from mm/mempolicy.c:68:
In function 'copy_from_user',
    inlined from 'compat_sys_get_mempolicy' at mm/mempolicy.c:1415:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
crypto/anubis.c: In function 'anubis_crypt':
crypto/anubis.c:581: warning: 'inter' is used uninitialized in this function
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/drm/drmP.h:65,
                 from drivers/gpu/drm/radeon/radeon_state.c:30:
In function 'copy_from_user',
    inlined from 'radeon_cp_clear' at drivers/gpu/drm/radeon/radeon_state.c:2171:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from drivers/message/i2o/config-osm.c:39:
drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
drivers/message/i2o/i2o_config.c:881: warning: cast to pointer from integer of different size
drivers/message/i2o/i2o_config.c:936: warning: cast to pointer from integer of different size
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from drivers/message/i2o/config-osm.c:22:
In function 'copy_from_user',
    inlined from 'i2o_cfg_passthru32' at drivers/message/i2o/i2o_config.c:684:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'i2o_cfg_passthru' at drivers/message/i2o/i2o_config.c:919:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from /usr/src/devel/arch/x86/include/asm/sections.h:5,
                 from /usr/src/devel/arch/x86/include/asm/hw_irq.h:26,
                 from include/linux/irq.h:351,
                 from /usr/src/devel/arch/x86/include/asm/hardirq.h:5,
                 from include/linux/hardirq.h:7,
                 from include/linux/interrupt.h:12,
                 from net/core/pktgen.c:135:
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:877:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1145:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1252:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1274:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1298:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1321:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1344:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1365:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1386:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1407:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1429:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1446:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1769:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1800:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/net/checksum.h:25,
                 from include/linux/skbuff.h:28,
                 from include/linux/icmpv6.h:82,
                 from net/compat.c:19:
In function 'copy_from_user',
    inlined from 'compat_sys_socketcall' at net/compat.c:792:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
drivers/net/pcmcia/nmclan_cs.c: In function 'nmclan_config':
drivers/net/pcmcia/nmclan_cs.c:628: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at include/pcmcia/ds.h:201)
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/linux/poll.h:14,
                 from drivers/scsi/sg.c:44:
In function 'copy_from_user',
    inlined from 'sg_proc_write_dressz' at drivers/scsi/sg.c:2399:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'sg_proc_write_adio' at drivers/scsi/sg.c:2376:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/linux/poll.h:14,
                 from drivers/net/tun.c:49:
In function 'copy_from_user',
    inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1246:
/usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

