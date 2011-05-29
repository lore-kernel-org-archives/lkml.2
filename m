Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1E2UO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:14:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:45313 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1E2UOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:14:55 -0400
Date: Sun, 29 May 2011 22:07:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrew Lutomirski <luto@mit.edu>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
In-Reply-To: <BANLkTinF1SGtFK+Khba4fAaox1Ran1KTtA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105292206470.4411@swampdragon.chaosbits.net>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu> <alpine.LNX.2.00.1105292146470.4411@swampdragon.chaosbits.net> <alpine.LNX.2.00.1105292152310.4411@swampdragon.chaosbits.net>
 <BANLkTinF1SGtFK+Khba4fAaox1Ran1KTtA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-932590342-1306699626=:4411"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-932590342-1306699626=:4411
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 29 May 2011, Andrew Lutomirski wrote:

> On Sun, May 29, 2011 at 3:54 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Sun, 29 May 2011, Jesper Juhl wrote:
> >
> >> On Fri, 27 May 2011, Andy Lutomirski wrote:
> >>
> >> > Now the only way to issue a syscall with side effects through the
> >> > vsyscall page is to call a misaligned instruction.  I haven't
> >> > checked for that.
> >> >
> >> > Signed-off-by: Andy Lutomirski <luto@mit.edu>
> >> > ---
> >> >  arch/x86/include/asm/traps.h    |    4 +++
> >> >  arch/x86/include/asm/vsyscall.h |    6 +++++
> >> >  arch/x86/kernel/entry_64.S      |    2 +
> >> >  arch/x86/kernel/traps.c         |    4 +++
> >> >  arch/x86/kernel/vsyscall_64.c   |   47 ++++++++++++++++++++++++++++++++++-----
> >> >  5 files changed, 57 insertions(+), 6 deletions(-)
> >> >
> >>
> >> one very tiny nit below.
> >>
> >> [...]
> >> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> >> > index b9b6716..d34894e 100644
> >> > --- a/arch/x86/kernel/traps.c
> >> > +++ b/arch/x86/kernel/traps.c
> >> > @@ -872,6 +872,10 @@ void __init trap_init(void)
> >> >     set_bit(SYSCALL_VECTOR, used_vectors);
> >> >  #endif
> >> >
> >> > +   set_system_intr_gate(0xCC, &intcc);
> >> > +   set_bit(0xCC, used_vectors);
> >> > +   printk(KERN_ERR "intcc gate isntalled\n");
> >>
> >> Let's spell the error message correctly:
> >>
> >>       printk(KERN_ERR "intcc gate installed\n");
> >>
> > Hmm, why is this KERN_ERR btw? Shouldn't it just be KERN_NOTICE or
> > KERN_INFO ?
> 
> IMO it shouldn't be there at all.  It was a debugging leftover that I
> forgot to delete.
> 
Just removing it sounds good to me :)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-932590342-1306699626=:4411--
