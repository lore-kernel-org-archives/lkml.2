Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1HBFDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:03:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:38494 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1HBFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:03:15 -0400
Date: Tue, 2 Aug 2011 01:02:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <linux-arch@vger.kernel.org>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Message-ID: <20110802050254.GI11811@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <20110728071556.GA6497@elte.hu>
 <20110728154229.GA19589@windriver.com>
 <20110729112054.eaf20e1875990b05e9545d81@canb.auug.org.au>
 <CAMuHMdUJbZsJ1Q0DM4h3uGVCpe+q=28oxphbLzQ6kW4bn9ZoHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUJbZsJ1Q0DM4h3uGVCpe+q=28oxphbLzQ6kW4bn9ZoHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 01/08/2011 (Mon 13:49) Geert Uytterhoeven wrote:

> Hi Paul,
> 
> On Fri, Jul 29, 2011 at 03:20, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Thu, 28 Jul 2011 11:42:29 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >> [Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 28/07/2011 (Thu 09:15) Ingo Molnar wrote:
> >>
> >> > * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >> >
> >> > > I don't think there really is any rocket science or contentious
> >> > > stuff here. It is a sensible cleanup that adds organization and
> >> > > speeds up compiles. The RFC I'm hoping for is more about how/when
> >> > > we want to get this in tree.
> >> >
> >> > I'd suggest to stick it into linux-next ASAP, leave there for a few
> >> > days and after fixing any potential fallout send it Linuswards.
> >>
> >> Hi Stephen,
> >>
> >> Would you please add this to linux-next?
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git#module.h-split
> >
> > OK, I will add it today.
> 
> This causes several failures in m68k defconfig (and allmodconfig, FWIW):
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/4428037/
> (http://kisskb.ellerman.id.au/kisskb/buildresult/4414683/)
> 
> Still recovering from holidays, so no patches attached.

I grabbed a m68k toolchain (and several others I didn't have)
and expanded the arch support outside of the original testing
I did on x86/x86_64/mips/arm/powerpc/sparc to include m68k.

So your defconfig is restored green again, once it comes around in
the build (it appears down in the order) -- and for the modconfig,
it hasn't been building green for a while, but I still went over
the log looking for and fixing any module.h related fallout.

I've just double checked it again and attached a local defconfig build
log below.

Thanks,
Paul.

paul@yow-lpgnfs-02:~/git/module.h/linux-2.6.git$ make O=../m68k-def -j50 2>&1 |grep 'warning:\|error:'
<stdin>:1522:2: warning: #warning syscall recvmmsg not implemented
<stdin>:1554:2: warning: #warning syscall sendmmsg not implemented
/home/paul/git/module.h/linux-2.6.git/arch/m68k/mvme147/config.c:152:2: warning: #warning check me!
/home/paul/git/module.h/linux-2.6.git/arch/m68k/mvme16x/config.c:261:2: warning: #warning check me!
/home/paul/git/module.h/linux-2.6.git/security/keys/keyctl.c:1521:2: warning: #warning TIF_NOTIFY_RESUME not implemented
/home/paul/git/module.h/linux-2.6.git/kernel/async.c:272:10: warning: 'starttime.tv64' may be used uninitialized in this function
/home/paul/git/module.h/linux-2.6.git/kernel/async.c:123:10: warning: 'calltime.tv64' may be used uninitialized in this function
/home/paul/git/module.h/linux-2.6.git/drivers/md/dm.c:1052:3: warning: statement with no effect
/home/paul/git/module.h/linux-2.6.git/drivers/md/dm.c:1079:3: warning: statement with no effect
/home/paul/git/module.h/linux-2.6.git/drivers/md/dm-table.c:1193:2: warning: statement with no effect
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:280:12: warning: 'hp_sdc_rtc_set_rt' defined but not used
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:320:12: warning: 'hp_sdc_rtc_set_fhs' defined but not used
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:360:12: warning: 'hp_sdc_rtc_set_i8042timer' defined but not used
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:112:20: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:179:20: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result
/home/paul/git/module.h/linux-2.6.git/drivers/input/misc/hp_sdc_rtc.c:183:20: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result
/home/paul/git/module.h/linux-2.6.git/include/net/netfilter/xt_log.h:50:3: warning: value computed is not used
/home/paul/git/module.h/linux-2.6.git/include/net/netfilter/xt_log.h:50:3: warning: value computed is not used
/home/paul/git/module.h/linux-2.6.git/drivers/scsi/libsas/sas_scsi_host.c:117:3: warning: case value '2' not in enumerated type 'enum exec_status'
paul@yow-lpgnfs-02:~/git/module.h/linux-2.6.git$ ls -l ../m68k-def/vmlinux
-rwxr-xr-x 1 paul paul 4951289 2011-08-02 00:59 ../m68k-def/vmlinux
paul@yow-lpgnfs-02:~/git/module.h/linux-2.6.git$ 

