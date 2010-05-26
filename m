Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0EZMmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab0EZMmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:42:06 -0400
Date: Wed, 26 May 2010 14:40:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage
	of child->mm
Message-ID: <20100526124006.GA28358@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> <20100525102345.GA23574@redhat.com> <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Mike Frysinger wrote:
>
> On Tue, May 25, 2010 at 06:23, Oleg Nesterov wrote:
> >        - arch/blackfin/kernel/ptrace.c:is_user_addr_valid()
> >          needs mmap_sem around find_vma()
> >
> >          The lockless access to mm->context.sram_list doesn't look
> >          safe to me.
> >
> >          If we add get_task_mm() - this protects us against
> >          destroy_context() only. What is the tracee's sub-thread
> >          does sys_sram_alloc() or sys_sram_free() in parallel?
>
> i dont believe there are any code paths in UP systems where this would
> be a practical problem because sram_list is only updated by syscalls
> from userspace.

Yes sure, UP && !PREEMPT is safe.

> we probably should add proper locking to this
> structure though.

Agreed. I'll try to make the trivial patch tomorrow. I think we
can just use mm->mmap_sem, is_user_addr_valid() needs this lock
for find_vma() anyway.

Oleg.

