Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab0EYR2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:28:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51898 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab0EYR2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=I52dQifNXiW9Yq4L67K/cwjQxvDiLN6ybaea7GeMtJ7iGjQAkymqxg30qDE+qmYM7h
         uNsxskLHK9r66QudqNY2txMQeHgBUcT5M22n8xAf8CdTy7phJVBrCR19RimhXzCYSO63
         7scUHaxmoeqfjeDlDX2ugjMjADtqQKyA87xso=
MIME-Version: 1.0
In-Reply-To: <20100525102345.GA23574@redhat.com>
References: <20100524234250.F158849A56@magilla.sf.frob.com> 
	<1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> 
	<20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> 
	<20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> 
	<20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> 
	<20100525102345.GA23574@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 25 May 2010 13:28:19 -0400
Message-ID: <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com>
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage of 
	child->mm
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 06:23, Oleg Nesterov wrote:
>        - arch/blackfin/kernel/ptrace.c:is_user_addr_valid()
>          needs mmap_sem around find_vma()
>
>          The lockless access to mm->context.sram_list doesn't look
>          safe to me.
>
>          If we add get_task_mm() - this protects us against
>          destroy_context() only. What is the tracee's sub-thread
>          does sys_sram_alloc() or sys_sram_free() in parallel?

i dont believe there are any code paths in UP systems where this would
be a practical problem because sram_list is only updated by syscalls
from userspace.  we probably should add proper locking to this
structure though.  i'll open a tracker item about it, thanks !
-mike
