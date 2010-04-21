Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0DUJi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0DUJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:38:57 -0400
Date: Wed, 21 Apr 2010 11:38:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
 declaration
In-Reply-To: <20100421060651.GB4467@cr0.nay.redhat.com>
Message-ID: <alpine.LNX.2.00.1004211138320.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de> <20100420100949.GB5317@cr0.nay.redhat.com> <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net> <4BCDDFBB.40805@web.de>
 <20100421060651.GB4467@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Amerigo Wang wrote:

> >  CC      arch/um/sys-i386/elfcore.o
> >In file included from /data/linux-2.6/include/linux/elf.h:8,
> >                 from /data/linux-2.6/arch/um/sys-i386/elfcore.c:2:
> >/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: ‘struct task_struct’ declared inside parameter list
> >/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: its scope is only this definition or declaration, which is probably not what you want
> >
> >I guess not many people build against i386 hosts anymore, so this
> >remained widely unnoticed.
> >
> >> 
> >> If it built before, without having a task_struct declaration, I think
> >> that means that the elf_core_copy_fpregs was never used.  The
> >> task_struct * in the declaration would become a private task_struct,
> >> known only to the declaration.  If the implementation or callers have
> >> the regular task_struct, it will be a different one, and the
> >> prototypes will conflict due to the different types of the first
> >> parameter.
> >
> >This is just a forward declaration (that many arch elf header include),
> >so no such problem exists.
> >
> >BTW, to answer the other question in this thread: We have a circular
> >dependency that prevents including sched.h.
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This is the right reason to do this. Ok then, thanks.
> 
> But it looks like x86_64 needs this too.
> 
> 
> BTW, I don't think compile warning fixes are trivial enough to go
> to trivial@kernel.org.

Why?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
