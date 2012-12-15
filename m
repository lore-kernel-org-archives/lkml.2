Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2LOQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:35:40 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:43175 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2LOQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:35:39 -0500
Date: Sat, 15 Dec 2012 17:35:35 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
Message-ID: <20121215163535.GB229@x4>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121215163323.GA229@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.12.15 at 17:33 +0100, Markus Trippelsdorf wrote:
> On 2012.12.14 at 17:47 -0800, Linus Torvalds wrote:
> > On Fri, Dec 14, 2012 at 5:41 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > I was wrong. It's not the x86 UAPI split, it's the DT pull. More people added.
> > 
> > Looking at the merge (just in case it could have done something odd),
> > I'm starting to worry that this is some nasty heisenbug, and my
> > bisection is not trustworthy at all. Because the DT pull sure as heck
> > doesn't look like a likely candidate for anything either.
> > 
> > Ho humm. Anybody else see anything strange?
> 
> Yes. I'm seeing a BUG early during boot on my machine (RIP=NULL):
>  
>  BUG: unable to handle kernel NULL pointer dereference at           (null)
> 
> This is caused by:
> 
> commit 53b87cf088e2ea68d7c59619d0214cc15bb76133
> Author: Matt Fleming <matt.fleming@intel.com>
> Date:   Fri Sep 7 18:23:51 2012 +0100
> 
>     x86, mm: Include the entire kernel memory map in trampoline_pgd
>     
>     There are various pieces of code in arch/x86 that require a page table
>     with an identity mapping. Make trampoline_pgd a proper kernel page
>     table, it currently only includes the kernel text and module space
>     mapping.
>     
>     One new feature of trampoline_pgd is that it now has mappings for the
>     physical I/O device addresses, which are inserted at ioremap()
>     time. Some broken implementations of EFI firmware require these
>     mappings to always be around.
>     
>     Acked-by: Jan Beulich <jbeulich@suse.com>
>     Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 

Adding Matt to CC.

-- 
Markus
