Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184Ab0KQR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:59:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54792 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934788Ab0KQR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:59:33 -0500
Date: Wed, 17 Nov 2010 09:59:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for November 17
Message-Id: <20101117095920.2b9e2e6a.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTinBiGOPptOY18-D+=djKLsJj75mXxL6ht6xNJXL@mail.gmail.com>
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>
	<AANLkTinBiGOPptOY18-D+=djKLsJj75mXxL6ht6xNJXL@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 18:23:20 +0100 Zimny Lech wrote:

> Ave
> 
> 2010/11/17 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101116:
> >
> 
> I think that this is well know
>   LD [M]  sound/oss/sound.o
> make[3]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
> `sound/oss/pss_boot.h'.  Stop.
> make[2]: *** [sound/oss] Error 2
> make[1]: *** [sound] Error 2
> make: *** [sub-make] Error 2
> 
> This one can be interesting
> 
>   GEN     /home/test/linux-2.6-obj/Makefile
> scripts/kconfig/conf --silentoldconfig Kconfig
> warning: (MTD_NAND && MTD || MTD_DOC2000 && MTD || MTD_DOC2001 && MTD
> || MTD_DOC2001PLUS && MTD) selects MTD_NAND_IDS which has unmet direct
> dependencies (MTD
>  && MTD_NAND)
> warning: (MTD_NAND && MTD || MTD_DOC2000 && MTD || MTD_DOC2001 && MTD
> || MTD_DOC2001PLUS && MTD) selects MTD_NAND_IDS which has unmet direct
> dependencies (MTD
>  && MTD_NAND)
>   Using /home/test/linux-2.6 as source for kernel
>   GEN     /home/test/linux-2.6-obj/Makefile
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from
> /home/test/linux-2.6/arch/x86/include/asm/suspend_64.h:10:0,
>                  from /home/test/linux-2.6/arch/x86/include/asm/suspend.h:4,
>                  from /home/test/linux-2.6/arch/x86/kernel/asm-offsets_64.c:20,
>                  from /home/test/linux-2.6/arch/x86/kernel/asm-offsets.c:4:
> /home/test/linux-2.6/arch/x86/include/asm/i387.h: In function 'irq_ts_save':
> /home/test/linux-2.6/arch/x86/include/asm/i387.h:348:2: error:
> implicit declaration of function 'kernel_locked'
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [sub-make] Error 2
> 
> 
> Config attached.


Why was #include <linux/smp_lock.h> removed from <linux/hardirq.h> ?

I added #include <linux/smp_lock.h> to i387.h, but them mm/filemap.c build fails
with the same error:

linux-next-20101117/mm/filemap.c: In function 'iov_iter_copy_from_user_atomic':
linux-next-20101117/mm/filemap.c:1936: error: implicit declaration of function 'kernel_locked'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
