Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1EYQHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:07:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49445 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757457Ab1EYQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:07:03 -0400
X-Sasl-enc: 3fRKZt+NuAQA3kC0N1LQf4gtarfwCl8V0R+EJUENEnHn 1306339621
Date: Wed, 25 May 2011 13:06:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525160656.GB25225@khazad-dum.debian.net>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525070604.GE429@elte.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
> >  	/* Index into per_cpu list: */
> >  	u16			cpu_index;
> >  #endif
> > +	/* CPU update signature */
> > +	u32			x86_cpu_update;
> 
> Btw,. there's one subtle thing here: it's possible to have *different* 
> microcode versions on different CPUs in te system.
> 
> This can happen if for example the BIOS somehow does not apply the right 
> microcode to all CPUs. It can also happen if physically different microcode 
> version CPUs are mixed. In theory people can mix steppings as well.

In PRACTICE people WILL mix steppings as well.

I have some boxes like that, here.  It is especifically supported by
server vendors, BIOS vendors, and also by Intel.  And it happens easily
when people decide to add processors to a non-maxed-out box a few years
after it has been acquired.

Heck, I am pretty sure at least one of those boxes with mismatched
steppings we have here was SOLD to us by IBM Brazil already with
mismatched steppings installed.

So, please consider this a field report that mixed CPU steppings in X86
SMP boxes are somewhat common.

> been brought online, and print some very visible boot warning message if 
> there's a mismatch between the steppings or microcode versions? Perhaps also 
> taint the kernel.

Mismatched microcode within processors with the same processor
identification (the full one, as used by the microcode matching logic)
would be something to *fix* in the first place (we should be updating CPU
microcode before we bring the CPU online anyway) and it would be nice to
warn if we don't have the suitable microcode and the BIOS screwed it up,
indeed...

But mismatched stepping?  We cannot taint or warn on mismatched stepping,
it is an explicitly supported configuration by the hardware and firmware
vendors.

BTW, microcode versions, at least for Intel, do not match across different
steppings (i.e. different processor signatures).  They do not always match
even across CPUs with the same processor signature but different processor
flags!   In fact, it is RARE when they do match.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
