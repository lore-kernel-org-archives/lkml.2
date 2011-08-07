Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1HGMTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 08:19:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56245 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1HGMTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 08:19:18 -0400
Date: Sun, 7 Aug 2011 14:19:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
Message-ID: <20110807121913.GA7007@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, lueckintel@yahoo.com,
	kimwooyoung@gmail.com, Suresh Siddha <suresh.b.siddha@intel.com>
References: <4E3C8B8A.3080007@zytor.com>
 <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
 <20110806064552.GA13220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110806064552.GA13220@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 08:45:52AM +0200, Ingo Molnar wrote:
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index 9682ec5..6ae5e3a 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -873,9 +873,17 @@ void __init trap_init(void)
> >  #endif
> >  
> >  #ifdef CONFIG_X86_64
> > -	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
> > -	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
> > -	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
> > +	BUG_ON(test_bit(VSYSCALL0_EMU_VECTOR, used_vectors));
> > +	set_system_intr_gate(VSYSCALL0_EMU_VECTOR, &emulate_vsyscall0);
> > +	set_bit(VSYSCALL0_EMU_VECTOR, used_vectors);
> > +
> > +	BUG_ON(test_bit(VSYSCALL1_EMU_VECTOR, used_vectors));
> > +	set_system_intr_gate(VSYSCALL1_EMU_VECTOR, &emulate_vsyscall1);
> > +	set_bit(VSYSCALL1_EMU_VECTOR, used_vectors);
> > +
> > +	BUG_ON(test_bit(VSYSCALL2_EMU_VECTOR, used_vectors));
> > +	set_system_intr_gate(VSYSCALL2_EMU_VECTOR, &emulate_vsyscall2);
> > +	set_bit(VSYSCALL2_EMU_VECTOR, used_vectors);
> >  #endif

..

> Surprisingly, this looks a bit cleaner to me than the original code,
> as the emulated syscalls separate out so nicely.
>
> The flip side is using up more of our vector space - but realistically
> we could put all this code behind a default-off LEGACY_VSYSCALL switch
> a year or two down the line, when distros have ugpraded glibc.

This probably needs an entry in <Documentation/feature-removal-schedule.txt>.

Also, what do we do with userspace which decides to hardcode "int 0x4[012]"
somewhere in the meantime?

Thanks.

-- 
Regards/Gruss,
    Boris.
