Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1GVUPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:15:34 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43749 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755132Ab1GVUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:15:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L4ytpbFHbTdc/xkG1xJEyTXuguPmfBqulY1LjY3CvTGDHeExsMur0p7a/31nQ48PlwjhYAu/+7K6mF84sOkoR5OzqbD/H25rCZvMf1oiMEKvMUHuvXNKtf6FvU6KzrH7;
Date: Fri, 22 Jul 2011 13:15:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Richard Weinberger <richard@nod.at>
Cc: JBeulich@novell.com, mingo@elte.hu, akpm@linux-foundation.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 22 (uml)
Message-Id: <20110722131530.7c8949a3.rdunlap@xenotime.net>
In-Reply-To: <201107222055.35341.richard@nod.at>
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
	<20110722085346.51565411.rdunlap@xenotime.net>
	<201107222055.35341.richard@nod.at>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 20:55:34 +0200 Richard Weinberger wrote:

> Am Freitag 22 Juli 2011, 17:53:46 schrieben Sie:
> > On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:
> > > Hi all,
> > 
> > uml build on i386 fails with:
> > 
> > arch/um/sys-i386/built-in.o: In function `call_rwsem_down_read_failed':
> > linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:93: undefined
> > reference to `rwsem_down_read_failed' arch/um/sys-i386/built-in.o: In
> > function `call_rwsem_down_write_failed':
> > linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:105: undefined
> > reference to `rwsem_down_write_failed' arch/um/sys-i386/built-in.o: In
> > function `call_rwsem_wake':
> > linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:118: undefined
> > reference to `rwsem_wake' arch/um/sys-i386/built-in.o: In function
> > `call_rwsem_downgrade_wake':
> > linux-next-20110722/arch/um/sys-i386/../../x86/lib/rwsem.S:130: undefined
> > reference to `rwsem_downgrade_wake'
> > 
> 
> Jan,
> 
> "x86: Unify rwsem assembly implementation" broke the UML build on i386.
> Please compile test you changes or CC me when you are touch something in arch/um/.
> 
> make ARCH=um SUBARCH=i386
> and
> make ARCH=um SUBARCH=x86_64
> 
> does not hurt. :-)

Ack.

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

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/um/sys-i386/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
> index 15587ed..87b659d 100644
> --- a/arch/um/sys-i386/Makefile
> +++ b/arch/um/sys-i386/Makefile
> @@ -8,7 +8,8 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
>  
>  obj-$(CONFIG_BINFMT_ELF) += elfcore.o
>  
> -subarch-obj-y = lib/rwsem.o lib/string_32.o
> +subarch-obj-y = lib/string_32.o
> +subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
>  subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
>  subarch-obj-$(CONFIG_MODULES) += kernel/module.o
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
