Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1HANtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:49:20 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:43192 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HANtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:49:17 -0400
Date: Mon, 1 Aug 2011 17:49:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Richard Weinberger <richard@nod.at>
Cc: serge.hallyn@canonical.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
Subject: Re: shm updates broke UML
Message-ID: <20110801134911.GA11705@albatros>
References: <201108011541.59640.richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108011541.59640.richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Aug 01, 2011 at 15:41 +0200, Richard Weinberger wrote:
> 5774ed01 (shm: handle separate PID namespaces case)
> b34a6b1d (ipc: introduce shm_rmid_forced sysctl)
> 4c677e2e (shm: optimize locking and ipc_namespace getting)
> 
> broke UML on i386.
> It crashes while starting up by SIGSEGV.
> exit_shm() seems to be the evil doer.

I was reported 20 mins ago that it's reproducable on MIPS too.

> Reverting all three patches make UML work again.

Can you confirm that 5774ed01 breaks the boot? (it is for MIPS)


> Commit 5774ed01 removed the !ns->shm_rmid_forced check, maybe this is wrong?

No, it's not the reason.

> ---cut---
> #13 0x08067efb in hard_handler (sig=11) at arch/um/os-Linux/sys-i386/signal.c:12
> #14 <signal handler called>
> #15 __list_add (sem=0x824cc98, subclass=0) at include/linux/list.h:44
> #16 list_add_tail (sem=0x824cc98, subclass=0) at include/linux/list.h:76
> #17 __down_write_nested (sem=0x824cc98, subclass=0) at lib/rwsem-spinlock.c:232
> #18 0x081c7ba1 in __down_write (sem=0x824cc98) at lib/rwsem-spinlock.c:252
> #19 0x081c74a3 in down_write (sem=0x824cc98) at kernel/rwsem.c:51
> #20 0x08139913 in exit_shm (task=0x9c73b60) at ipc/shm.c:308
> #21 0x08075649 in do_exit (code=0) at kernel/exit.c:983
> #22 0x08081dd2 in ____call_usermodehelper (data=0x9c6bce0) at kernel/kmod.c:187
> #23 0x08065c18 in run_kernel_thread (fn=0x8081ce4 <____call_usermodehelper>, arg=0x9c6bce0, 
> jmp_ptr=0x9c73d94)
>     at arch/um/os-Linux/process.c:268
> #24 0x080588cb in new_thread_handler () at arch/um/kernel/process.c:153
> #25 0x00000000 in ?? ()
> ---cut---

Can you post the whole oops message?  I'd want to see what pointer is
NULL.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
