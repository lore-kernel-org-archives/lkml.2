Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab1GYGyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:54:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:5156 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1GYGya convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 25 Jul 2011 02:54:30 -0400
Message-Id: <4E2D2F40020000780004F5CE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 25 Jul 2011 07:54:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, "Richard Weinberger" <richard@nod.at>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <akpm@linux-foundation.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for July 22 (uml)
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
 <20110722085346.51565411.rdunlap@xenotime.net>
 <201107222055.35341.richard@nod.at>
In-Reply-To: <201107222055.35341.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.07.11 at 20:55, Richard Weinberger <richard@nod.at> wrote:
> Am Freitag 22 Juli 2011, 17:53:46 schrieben Sie:
>> On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:
>> > Hi all,
>> 
>> uml build on i386 fails with:
>> 
>> arch/um/sys-i386/built-in.o: In function `call_rwsem_down_read_failed':
>> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:93: undefined
>> reference to `rwsem_down_read_failed' arch/um/sys-i386/built-in.o: In
>> function `call_rwsem_down_write_failed':
>> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:105: undefined
>> reference to `rwsem_down_write_failed' arch/um/sys-i386/built-in.o: In
>> function `call_rwsem_wake':
>> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:118: undefined
>> reference to `rwsem_wake' arch/um/sys-i386/built-in.o: In function
>> `call_rwsem_downgrade_wake':
>> linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:130: undefined
>> reference to `rwsem_downgrade_wake'
>> 
> 
> Jan,
> 
> "x86: Unify rwsem assembly implementation" broke the UML build on i386.
> Please compile test you changes or CC me when you are touch something in 
> arch/um/.
> 
> make ARCH=um SUBARCH=i386
> and
> make ARCH=um SUBARCH=x86_64
> 
> does not hurt. :-)

I'm sorry for that - I actually meant to, but then forgot.

> Thanks,
> //richard
> 
> ---
> 
> From b9ec24beb55276d74fdf4f9f9607c69fc8662b72 Mon Sep 17 00:00:00 2001
> From: Richard Weinberger <richard@nod.at>
> Date: Fri, 22 Jul 2011 20:46:32 +0200
> Subject: [PATCH] um: Make rwsem.S depend on CONFIG_RWSEM_XCHGADD_ALGORITHM
> 
> rwsem.S can only be used with CONFIG_RWSEM_XCHGADD_ALGORITHM.
> This unbreaks the UML build on i386.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Jan Beulich <jbeulich@novell.com>

> ---
>  arch/um/sys-i386/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
> index 15587ed..87b659d 100644
> --- a/arch/um/sys-i386/Makefile
> +++ b/arch/um/sys-i386/Makefile
> @@ -8,7 +8,8 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o 
> ptrace.o \
>  
>  obj-$(CONFIG_BINFMT_ELF) += elfcore.o
>  
> -subarch-obj-y = lib/rwsem.o lib/string_32.o
> +subarch-obj-y = lib/string_32.o
> +subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
>  subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
>  subarch-obj-$(CONFIG_MODULES) += kernel/module.o
>  




