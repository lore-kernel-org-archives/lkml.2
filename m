Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2DVVX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab2DVVV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:21:26 -0400
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
From: Mark Salter <msalter@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Date: Sun, 22 Apr 2012 17:21:18 -0400
In-Reply-To: <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com>
	 <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1335129679.12741.4.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-21 at 01:01 -0400, Mike Frysinger wrote:
> On Fri, Apr 20, 2012 at 17:47, Mark Salter wrote:
> > --- a/arch/c6x/kernel/process.c
> > +++ b/arch/c6x/kernel/process.c
> >
> > +
> > +/* Fill in the fpu structure for a core dump. This is easy -- we don't have any */
> > +int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
> > +{
> > +       /* Not valid */
> > +       return 0;
> > +}
> 
> you could avoid this like Blackfin has:
> arch/blackfin/include/asm/elf.h:
> #define ELF_CORE_COPY_FPREGS(...) 0     /* Blackfin has no FPU */

Yes, thanks. That's a better way I missed.

> 
> > --- a/fs/Kconfig.binfmt
> > +++ b/fs/Kconfig.binfmt
> >
> >  config BINFMT_ELF_FDPIC
> >        bool "Kernel support for FDPIC ELF binaries"
> >        default y
> > -       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU))
> > +       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || TMS320C6X)
> 
> shouldn't the main arch symbol be "C6X" to match arch/c6x/ ?

It probably should have been. Most architectures use that convention but
there are notable exceptions like powerpc and sh.

> -mike


