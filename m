Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587Ab0KRVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:30:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54346 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0KRVaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:30:35 -0500
Date: Thu, 18 Nov 2010 13:29:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-11-17-17-03 uploaded
Message-Id: <20101118132900.2d7e2a11.randy.dunlap@oracle.com>
In-Reply-To: <73121.1290115539@localhost>
References: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org>
	<73121.1290115539@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 16:25:39 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 17 Nov 2010 17:03:30 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-11-17-17-03 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Using my current .config and a 'make oldconfig' dies a horrid quick death:


Hi,

Yep, this has been fixed in mainline now.

>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/suspend_64.h:10:0,
>                  from /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/suspend.h:4,
>                  from arch/x86/kernel/asm-offsets_64.c:20,
>                  from arch/x86/kernel/asm-offsets.c:4:
> /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/i387.h: In function 'irq_ts_save':
> /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/i387.h:348:2: error: implicit declaration of function 'kernel_locked'
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> static inline int irq_ts_save(void)
> {
>         /*
>          * If in process context and not atomic, we can take a spurious DNA fault.
>          * Otherwise, doing clts() in process context requires disabling preemption
>          * or some heavy lifting like kernel_fpu_begin()
>          */
>         if (!in_atomic())
>                 return 0;
> 
> in_atomic() did me in.  CONFIG_LOCK_KERNEL and CONFIG_BKL are both =y in this build.
> 
> Not sure if asm-offsets_64.c needs a #include <smp-locks.h> or if it's something else...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
