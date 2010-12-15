Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0LOCae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:30:34 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47920 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab0LOCac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:30:32 -0500
Date: Wed, 15 Dec 2010 08:00:41 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 5/21] Rename compat versions of the reusable core
 generation routines
Message-ID: <20101215080041.5c3ea5bc@suzukikp>
In-Reply-To: <20101214155708.GC11400@redhat.com>
References: <20101214152259.67896960@suzukikp>
	<20101214153314.04d05dd2@suzukikp>
	<20101214155708.GC11400@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 16:57:08 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/14, Suzuki K. Poulose wrote:
> >
> > Rename the ELF class specific functions reusable for the application core dump 
> > infrastructure. The compat ELF class routines are prepended with compat_ .
> >
> > Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> > ---
> >  fs/compat_binfmt_elf.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > Index: linux-2.6.36-rc7/fs/compat_binfmt_elf.c
> > ===================================================================
> > --- linux-2.6.36-rc7.orig/fs/compat_binfmt_elf.c
> > +++ linux-2.6.36-rc7/fs/compat_binfmt_elf.c
> > @@ -127,6 +127,13 @@ static void cputime_to_compat_timeval(co
> >  #define init_elf_binfmt		init_compat_elf_binfmt
> >  #define exit_elf_binfmt		exit_compat_elf_binfmt
> >
> > +/* Rename the functions that may be reused */
> > +#define fill_elf_header 	compat_fill_elf_header
> > +#define fill_psinfo		compat_fill_psinfo
> > +#define fill_prstatus		compat_fill_prstatus
> > +#define fill_extnum_info	compat_fill_extnum_info
> > +#define fill_auxv_note		compat_fill_auxv_note
> 
> Can't undestand.... Afaics, the kernel can't be compiled
> with this change until the next patches actually implement
> compat_xxx ?

The compat_binfmt_elf.c shares the actual ELF handling code from binfmt_elf.c (by 
#includ ing it). This patch renames the functions so that we can later export it. 
The "#include binfmt_elf.c" comes later in the compat_binfmt_elf.c. So we are fine.
> 
> This is not bisect friendly.
> 
> Oleg.
> 

